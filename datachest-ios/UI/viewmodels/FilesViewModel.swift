//
//  GoogleDriveFacade.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 08/03/2022.
//

import Foundation

extension FilesView {
    class FilesViewModel: ObservableObject {
        @Published var files: [GoogleDriveFileResponse] = []
        
        func uploadFile(fileUrl: URL) {
            let _ = GoogleDriveFileUploadSession(fileUrl: fileUrl) { closureGd in
                closureGd.createNewUploadSession(destinationFolder: .files, fileName: "testname") { _ in
                    closureGd.uploadFile()
                }
            }
        }
        
        func listFilesOnCloud() {
            let ccd = CommonCloudContainer()
            ccd.googleDriveGetOrCreateAllFolders() {
                GoogleDriveService.shared.listFiles(
                    q: .listItemsInFilesFolder(
                        folderId: ApplicationStore.shared.state.googleDriveFolderIds[.files] ?? ""
                    )
                ) { response in
                    guard let files = try? JSONDecoder().decode([GoogleDriveFileResponse].self, from: response.data) else {
                        ApplicationStore.shared.state.error = ApplicationError(error: .dataParsingError)
                        return
                    }
                    self.files = files
                }
            }
        }
    }
}
