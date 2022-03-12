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
    var uploadSessionsActive: [GoogleLargeFileUploadSession] = []

    private init() {}

    func uploadLargeFile(fileUrl: URL) {
        uploadSessionsActive.append(GoogleLargeFileUploadSession(fileUrl: fileUrl))
    }
}
