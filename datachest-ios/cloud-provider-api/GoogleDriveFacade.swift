//
//  GoogleDriveFacade.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 08/03/2022.
//

import Foundation

class GoogleDriveFacade {
    static let shared = GoogleDriveFacade()
    // toto by malo byt v store
    var activeUploadSessions: [GoogleDriveFileUploadSession] = []

    private init() {}

    func uploadFile(fileUrl: URL) {
        let gd = GoogleDriveFileUploadSession(fileUrl: fileUrl)
        gd.createNewUploadSession(destinationFolder: .files, fileName: "testname") { _ in
            gd.uploadFile()
        }
        // toto nech sa appenduje do storu
        activeUploadSessions.append(GoogleDriveFileUploadSession(fileUrl: fileUrl))
    }
    
    func listFilesOnCloud() {
        
    }
}
