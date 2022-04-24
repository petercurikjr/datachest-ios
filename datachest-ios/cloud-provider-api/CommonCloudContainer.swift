//
//  CommonCloudContainer.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/03/2022.
//

import Foundation
import Firebase

class CommonCloudContainer {
    let db: Firestore

    init() {
        self.db = Firestore.firestore()
    }
        
    func googleDriveGetOrCreateAllFolders(completion: @escaping () -> Void) {
        self.googleDriveGetOrCreateFolder(folderName: .datachest, parentId: nil) { rootId in
            let group = DispatchGroup()
            group.enter()
            self.googleDriveGetOrCreateFolder(folderName: .files, parentId: rootId) { _ in
                group.leave()
            }
            group.enter()
            self.googleDriveGetOrCreateFolder(folderName: .keyshareAndMetadata, parentId: rootId) { _ in
                group.leave()
            }
            
            group.notify(queue: DispatchQueue.main) {
                completion()
            }
        }
    }
    
    func microsoftOneDriveCheckOrCreateAllFolders(completion: @escaping () -> Void) {
        self.microsoftOneDriveCheckOrCreateFolder(
            metadata: MicrosoftOneDriveCreateItem(
                name: DatachestFolders.datachest.rawValue,
                folder: MicrosoftOneDriveEmptyObject(),
                conflictBehavior: "replace"
            ),
            parentFolder: nil
        ) {
            let group = DispatchGroup()
            group.enter()
            self.microsoftOneDriveCheckOrCreateFolder(
                metadata: MicrosoftOneDriveCreateItem(
                    name: DatachestFolders.files.rawValue,
                    folder: MicrosoftOneDriveEmptyObject(),
                    conflictBehavior: "replace"
                ),
                parentFolder: .datachest
            ) { group.leave() }
            group.enter()
            self.microsoftOneDriveCheckOrCreateFolder(
                metadata: MicrosoftOneDriveCreateItem(
                    name: DatachestFolders.keyshareAndMetadata.rawValue,
                    folder: MicrosoftOneDriveEmptyObject(),
                    conflictBehavior: "replace"
                ),
                parentFolder: .datachest
            ) { group.leave() }
            
            group.notify(queue: DispatchQueue.main) {
                completion()
            }
        }
    }
    
    func dropboxCheckOrCreateAllFolders(completion: @escaping () -> Void) {
        if let json = try? JSONEncoder().encode(DropboxListFilesRequest(path: DatachestFolders.root.rawValue, include_deleted: false)) {
            DropboxService.shared.listFiles(dataArg: json) { response in
                guard let items = try? JSONDecoder().decode(DropboxListFilesResponse.self, from: response.data) else {
                    DispatchQueue.main.async {
                        ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                    }
                    return
                }
                if items.entries.contains(where: { item in item.name == DatachestFolders.datachest.rawValue }) {
                    completion()
                }
                else {
                    let group = DispatchGroup()
                    group.enter()
                    self.dropboxCheckOrCreateFolder(dataArg: DropboxCreateItemCommit(path: DatachestFolders.files.full, mode: nil, autorename: nil)) { group.leave() }
                    group.enter()
                    self.dropboxCheckOrCreateFolder(dataArg: DropboxCreateItemCommit(path: DatachestFolders.keyshareAndMetadata.full, mode: nil, autorename: nil)) { group.leave() }
                    
                    group.notify(queue: DispatchQueue.main) {
                        completion()
                    }
                }
            }
        }
    }
    
    private func dropboxCheckOrCreateFolder(dataArg: DropboxCreateItemCommit, completion: @escaping () -> Void) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .withoutEscapingSlashes
        if let jsonData = try? jsonEncoder.encode(dataArg) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...2)) {
                DropboxService.shared.createFolder(dataArg: jsonData) { _ in
                    completion()
                }
            }
        }
    }
    
    private func microsoftOneDriveCheckOrCreateFolder(metadata: MicrosoftOneDriveCreateItem, parentFolder: DatachestFolders?, completion: @escaping () -> Void) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .withoutEscapingSlashes
        if let jsonData = try? jsonEncoder.encode(metadata) {
            MicrosoftOneDriveService.shared.createFolder(parentFolder: parentFolder, data: jsonData) { _ in
                completion()
            }
        }
    }
    
    private func googleDriveGetOrCreateFolder(folderName: DatachestFolders, parentId: String?, completion: @escaping (String) -> Void) {
        if ApplicationStore.shared.state.googleDriveFolderIds[folderName] != nil {
            completion(ApplicationStore.shared.state.googleDriveFolderIds[folderName]!)
            return
        }
        else {
            let query: GoogleDriveQuery = .getFolder(folderName: folderName, parentId: parentId)
            
            GoogleDriveService.shared.listFiles(q: query) { response in
                guard let items = try? JSONDecoder().decode(GoogleDriveListFilesResponse.self, from: response.data) else {
                    DispatchQueue.main.async {
                        ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                    }
                    return
                }
                if items.files.contains(where: { item in item.name == folderName.rawValue }) {
                    ApplicationStore.shared.state.googleDriveFolderIds[folderName] = items.files.first(where: { item in item.name == folderName.rawValue })!.id
                    completion(ApplicationStore.shared.state.googleDriveFolderIds[folderName]!)
                }
                else {
                    let metadata = GoogleDriveCreateItemMetadata(
                        name: folderName.rawValue,
                        mimeType: GoogleDriveItemMimeType.folder.rawValue,
                        parents: parentId != nil ? [parentId!] : nil
                    )
                    let jsonEncoder = JSONEncoder()
                    jsonEncoder.outputFormatting = .withoutEscapingSlashes
                    if let jsonData = try? jsonEncoder.encode(metadata) {
                        GoogleDriveService.shared.createFolder(metadata: jsonData) { response in
                            guard let createdFolder = try? JSONDecoder().decode(GoogleDriveFileResponse.self, from: response.data) else {
                                DispatchQueue.main.async {
                                    ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                                }
                                return
                            }

                            if createdFolder.name == folderName.rawValue {
                                ApplicationStore.shared.state.googleDriveFolderIds[folderName] = createdFolder.id
                                completion(ApplicationStore.shared.state.googleDriveFolderIds[folderName]!)
                            }
                        }
                    }
                }
            }
        }
    }
}
