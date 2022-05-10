//
//  MicrosoftOneDriveFileDownloadSession.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 31/03/2022.
//

import Foundation

class MicrosoftOneDriveFileDownloadSession: FileDownloadSession {
    var bytesDownloaded = 0
    var ongoingDownload: DatachestOngoingFileTransfer?

    init(fileId: String, fileName: String) {
        super.init(fileId: fileId, fileName: fileName, bufferSize: .microsoftOneDrive)
    }
    
    func downloadFile() {
        self.collectKeyShares() {
            MicrosoftOneDriveService.shared.downloadFile(fileId: self.fileId, ongoingDownloadId: self.ongoingDownload?.id) { response in
                self.decryptAndSaveFile(fileUrl: response.tmpUrl!)
                if let id = self.ongoingDownload?.id {
                    DispatchQueue.main.async {
                        ApplicationStore.shared.uistate.ongoingDownloads[id].finished = true
                    }
                }
            }
        }
    }
}
