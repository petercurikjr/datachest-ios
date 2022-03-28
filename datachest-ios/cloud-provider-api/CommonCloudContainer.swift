//
//  CommonCloudContainer.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/03/2022.
//

import Foundation

class CommonCloudContainer {
    func googleDriveGetOrCreateFolder(folderName: DatachestFolders, parentId: String?, completion: @escaping (String) -> Void) {
        if ApplicationStore.shared.state.googleDriveFolderIds[folderName] != nil {
            completion(ApplicationStore.shared.state.googleDriveFolderIds[folderName]!)
            return
        }
        else {
            let query: GoogleDriveQuery = .getFolder(folderName: folderName, parentId: parentId)
            
            GoogleDriveService.shared.listFiles(q: query) { response in
                guard let items = try? JSONDecoder().decode(GoogleDriveListFilesResponse.self, from: response.data) else {
                    print("error decoding")
                    return
                }
                if items.files.contains(where: { item in item.name == folderName.rawValue }) {
                    ApplicationStore.shared.state.googleDriveFolderIds[folderName] = items.files.first(where: { item in item.name == folderName.rawValue })!.id
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
                                print("error decoding")
                                return
                            }

                            if createdFolder.name == folderName.rawValue {
                                ApplicationStore.shared.state.googleDriveFolderIds[folderName] = createdFolder.id
                            }
                        }
                    }
                }
                completion(ApplicationStore.shared.state.googleDriveFolderIds[folderName]!)
            }
        }
    }
}
