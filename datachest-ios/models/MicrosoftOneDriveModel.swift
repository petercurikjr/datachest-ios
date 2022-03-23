//
//  MicrosoftOneDriveModel.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 16/03/2022.
//

import Foundation

struct MicrosoftOneDriveResumableUploadResponse: Codable {
    let uploadUrl: String
    let expirationDateTime: String
    let nextExpectedRanges: [String]
}

struct MicrosoftOneDriveFileResponse: Codable {
    let createdDateTime: String
    let id: String
    let lastModifiedDateTime: String
    let name: String
    let size: Int
}
