//
//  MicrosoftOneDriveFileDownloadSession.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 31/03/2022.
//

import Foundation

class MicrosoftOneDriveFileDownloadSession: FileDownloadSession {
    var bytesDownloaded = 0
    
    init(fileId: String, fileName: String) {
        super.init(fileId: fileId, fileName: fileName, bufferSize: .microsoftOneDrive)
    }
    
    func downloadFile() {
        self.collectKeyShares() {
            MicrosoftOneDriveService.shared.downloadFile(fileId: self.fileId) { response in
                self.decryptAndSaveFile(fileUrl: response.tmpUrl!)
            }
        }
    }
}
