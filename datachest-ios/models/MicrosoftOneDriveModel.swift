//
//  MicrosoftOneDriveModel.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 16/03/2022.
//

import Foundation

struct MicrosoftOneDriveDriveInfoResponse: Codable {
    let id: String
    let owner: MicrosoftOneDriveOwner
    let quota: MicrosoftOneDriveQuota
}

struct MicrosoftOneDriveOwner: Codable {
    let user: MicrosoftOneDriveUser
}

struct MicrosoftOneDriveUser: Codable {
    let id: String
    let displayName: String
}

struct MicrosoftOneDriveQuota: Codable {
    let total: Int64
    let remaining: Int64
}

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
