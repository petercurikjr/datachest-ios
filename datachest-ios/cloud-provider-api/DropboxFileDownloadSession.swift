//
//  DropboxFileDownloadSession.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 06/04/2022.
//

import Foundation

class DropboxFileDownloadSession: FileDownloadSession {
    var bytesDownloaded = 0
    
    init(fileId: String, fileName: String) {
        super.init(fileId: fileId, fileName: fileName, bufferSize: .dropbox)
    }
    
    func downloadFile() {
        self.collectKeyShares() {
            let downloadArg = DropboxDownloadFileMetadata(path: self.fileId)
            if let jsonData = try? JSONEncoder().encode(downloadArg) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    DropboxService.shared.downloadFile(downloadArg: jsonString) { response in
                        self.decryptAndSaveFile(fileUrl: response.tmpUrl!)
                    }
                }
            }
        }
    }
}

