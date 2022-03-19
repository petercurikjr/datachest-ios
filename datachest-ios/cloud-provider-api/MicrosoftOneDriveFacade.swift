//
//  MicrosoftOneDriveFacade.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 14/03/2022.
//

import Foundation

class MicrosoftOneDriveFacade {
    static let shared = MicrosoftOneDriveFacade()
    var activeUploadSessions: [MicrosoftOneDriveUploadSession] = []
    
    private init() {}
    
    func uploadFile(fileUrl: URL) {
        activeUploadSessions.append(MicrosoftOneDriveUploadSession(fileUrl: fileUrl))
    }
}
