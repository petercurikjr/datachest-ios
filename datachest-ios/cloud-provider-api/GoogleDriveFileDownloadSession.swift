//
//  GoogleDriveFileDownloadSession.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/03/2022.
//

import Foundation

class GoogleDriveFileDownloadSession: FileDownloadSession {
    var bytesDownloaded = 0
    var ongoingDownload: DatachestOngoingFileTransfer?
    
    init(fileId: String, fileName: String) {
        super.init(fileId: fileId, fileName: fileName, bufferSize: .googleDrive)
    }
    
    func downloadFile() {
        self.collectKeyShares() {
            GoogleDriveService.shared.downloadFile(fileId: self.fileId, ongoingDownloadId: self.ongoingDownload?.id) { response in
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
