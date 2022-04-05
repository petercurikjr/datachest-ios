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
        @Published var dropboxFiles: [DropboxFileResponse] = []
        
        /// Used for time delays between requests. Dropbox is sensitive to heavy traffic from one client
        var dropboxDidRequestFilesList = false
        
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
            if !self.dropboxDidRequestFilesList {
                self.dropboxDidRequestFilesList = true
                DropboxFacade.shared.listFilesOnCloud() { files in
                    DispatchQueue.main.async {
                        self.dropboxFiles = files
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.dropboxDidRequestFilesList = false
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
        
        func dropboxDownloadFile(file: DropboxFileResponse) {
            guard let availableSpace = DeviceHelper.shared.getAvailableStorageSpace(), file.size ?? 0 < availableSpace else {
                DispatchQueue.main.async {
                    ApplicationStore.shared.uistate.error = ApplicationError(error: .notEnoughStorageSpace)
                }
                return
            }
            let dpb = DropboxFileDownloadSession(fileId: file.id, fileName: file.name)
            dpb.downloadFile()
        }
    }
}
