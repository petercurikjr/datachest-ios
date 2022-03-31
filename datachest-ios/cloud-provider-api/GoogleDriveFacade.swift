//
//  GoogleDriveFacade.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 08/03/2022.
//

import Foundation

class GoogleDriveFacade {
    static let shared = GoogleDriveFacade()
    
    private init() {}
    
    func uploadFile(fileUrl: URL) {
        let _ = GoogleDriveFileUploadSession(fileUrl: fileUrl) { closureGd in
            closureGd.createNewUploadSession(destinationFolder: .files, fileName: nil) { _ in
                closureGd.uploadFile()
            }
        }
    }
    
    func listFilesOnCloud(completion: @escaping ([GoogleDriveFileResponse]) -> Void) {
        let ccd = CommonCloudContainer()
        ccd.googleDriveGetOrCreateAllFolders() {
            GoogleDriveService.shared.listFiles(
                q: .listItemsInFilesFolder(
                    folderId: ApplicationStore.shared.state.googleDriveFolderIds[.files] ?? ""
                )
            ) { response in
                guard let files = try? JSONDecoder().decode(GoogleDriveListFilesResponse.self, from: response.data) else {
                    DispatchQueue.main.async {
                        ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                    }
                    return
                }
                completion(files.files)
            }
        }
    }
    
    func getFileSize(fileId: String, completion: @escaping (Int) -> Void) {
        GoogleDriveService.shared.getFileSize(fileId: fileId) { response in
            guard let fileSize = try? JSONDecoder().decode(GoogleDriveFileSize.self, from: response.data) else {
                DispatchQueue.main.async {
                    ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                }
                return
            }
            completion(Int(fileSize.size) ?? 0)
        }
    }
}
