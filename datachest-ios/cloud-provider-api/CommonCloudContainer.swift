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
        
    func googleDriveGetOrCreateAllFolders(completion: @escaping () -> Void) {
        self.googleDriveGetOrCreateFolder(folderName: .root, parentId: nil) { rootId in
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
}
