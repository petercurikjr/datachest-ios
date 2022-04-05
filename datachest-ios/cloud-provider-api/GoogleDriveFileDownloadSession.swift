//
//  GoogleDriveFileDownloadSession.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/03/2022.
//

import Foundation

class GoogleDriveFileDownloadSession: FileDownloadSession {
    var bytesDownloaded = 0
    
    init(fileId: String, fileName: String) {
        super.init(fileId: fileId, fileName: fileName, bufferSize: .googleDrive)
    }
    
    func downloadFile() {
        self.collectKeyShares() {
            GoogleDriveService.shared.downloadFile(fileId: self.fileId) { response in
                self.decryptAndSaveFile(fileUrl: response.tmpUrl!)
            }
        }
    }
}
