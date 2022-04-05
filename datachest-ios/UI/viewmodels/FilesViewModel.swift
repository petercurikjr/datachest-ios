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
        @Published var microsoftOneDriveFiles: [MicrosoftOneDriveFileResponse] = []
        
        func listFilesOnCloud() {
            GoogleDriveFacade.shared.listFilesOnCloud() { files in
                DispatchQueue.main.async {
                    self.googleDriveFiles = files
                }
            }
            MicrosoftOneDriveFacade.shared.listFilesOnCloud() { files in
                DispatchQueue.main.async {
                    self.microsoftOneDriveFiles = files
                }
            }
        }
        
        func googleDriveDownloadFile(file: GoogleDriveFileResponse) {
            GoogleDriveFacade.shared.getFileSize(fileId: file.id) { fileSize in
                guard let availableSpace = DeviceHelper.shared.getAvailableStorageSpace(), fileSize < availableSpace else {
                    DispatchQueue.main.async {
                        ApplicationStore.shared.uistate.error = ApplicationError(error: .notEnoughStorageSpace)
                    }
                    return
                }
                let gd = GoogleDriveFileDownloadSession(fileId: file.id, fileName: file.name)
                gd.downloadFile()
            }
        }
        
        func microsoftOneDriveDownloadFile(file: MicrosoftOneDriveFileResponse) {
            guard let availableSpace = DeviceHelper.shared.getAvailableStorageSpace(), file.size < availableSpace else {
                DispatchQueue.main.async {
                    ApplicationStore.shared.uistate.error = ApplicationError(error: .notEnoughStorageSpace)
                }
                return
            }
            let mod = MicrosoftOneDriveFileDownloadSession(fileId: file.id, fileName: file.name)
            mod.downloadFile()
        }

    }
}
