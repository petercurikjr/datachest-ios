//
//  GoogleDriveFacade.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 08/03/2022.
//

import Foundation
import CryptoKit

class GoogleDriveFacade {
    static let shared = GoogleDriveFacade()
    var activeUploadSessions: [GoogleDriveFileUploadSession] = []

    private init() {}

    func uploadFile(fileUrl: URL) {
        let gd = GoogleDriveFileUploadSession(fileUrl: fileUrl)
        gd.createNewUploadSession(destinationFolderName: "Files", fileName: "testname") { resumableURL in
            gd.uploadFile()
        }
        activeUploadSessions.append(GoogleDriveFileUploadSession(fileUrl: fileUrl))
    }
}
