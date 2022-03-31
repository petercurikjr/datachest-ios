//
//  FilesViewModel.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 28/03/2022.
//

import Foundation

extension FilesView {
    class FilesViewModel: ObservableObject {
        @Published var googleDriveFiles: [GoogleDriveFileResponse] = []
        
        func downloadFile(fileId: String, fileName: String) {
            GoogleDriveFacade.shared.getFileSize(fileId: fileId) { fileSize in
                guard let availableSpace = DeviceHelper.shared.getAvailableStorageSpace(), fileSize < availableSpace else {
                    DispatchQueue.main.async {
                        ApplicationStore.shared.uistate.error = ApplicationError(error: .notEnoughStorageSpace)
                    }
                    return
                }
                let gd = GoogleDriveFileDownloadSession(fileId: fileId, fileName: fileName)
                gd.downloadFile()
            }
        }
        
        func listFilesOnCloud() {
            GoogleDriveFacade.shared.listFilesOnCloud() { files in
                DispatchQueue.main.async {
                    self.googleDriveFiles = files
                }
            }
        }
    }
}
