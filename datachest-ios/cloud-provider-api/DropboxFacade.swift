//
//  DropboxFacade.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation

class DropboxFacade {
    static let shared = DropboxFacade()
    var activeUploadSessions: [DropboxFileUploadSession] = []

    private init() {}

    func uploadFile(fileUrl: URL) {
        activeUploadSessions.append(DropboxFileUploadSession(fileUrl: fileUrl))
    }
}
