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

struct MicrosoftOneDriveFileResponse: Codable, Identifiable {
    let createdDateTime: String
    let id: String
    let lastModifiedDateTime: String
    let name: String
    let size: Int
}

struct MicrosoftOneDriveFilesResponse: Codable {
    let value: [MicrosoftOneDriveFileResponse]
}

struct MicrosoftOneDriveCreateItemRequest: Codable {
    let item: MicrosoftOneDriveCreateItem
}

struct MicrosoftOneDriveCreateItem: Codable {
    let name: String?
    let folder: MicrosoftOneDriveEmptyObject?
    let conflictBehavior: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case folder
        case conflictBehavior = "@microsoft.graph.conflictBehavior"
    }
}

struct MicrosoftOneDriveEmptyObject: Codable {}
