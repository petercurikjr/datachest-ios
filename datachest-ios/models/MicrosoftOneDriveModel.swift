//
//  MicrosoftOneDriveModel.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 16/03/2022.
//

import Foundation

struct MicrosoftOneDriveResponse: Codable {
    let oDataContext: String
    let oDataCount: Int
    let value: [MicrosoftOneDriveChild]
    
    private enum CodingKeys: String, CodingKey {
        case oDataContext = "@odata.context"
        case oDataCount = "@odata.count"
        case value
    }
}

struct MicrosoftOneDriveChild: Codable {
    let createdDateTime: String
    let cTag: String
    let eTag: String
    let id: String
    let lastModifiedDateTime: String
    let name: String
    let size: Int
    let webUrl: String
    let reactions: MicrosoftOneDriveReactions
    let createdBy: MicrosoftOneDriveTouchedBy
    let lastModifiedBy: MicrosoftOneDriveTouchedBy
    let parentReference: MicrosoftOneDriveParentReference
    let fileSystemInfo: MicrosoftOneDriveFileSystemInfo
    let folder: MicrosoftOneDriveFolder
    let specialFolder: MicrosoftOneDriveSpecialFolder?
}

struct MicrosoftOneDriveReactions: Codable {
    let commentCount: Int
}

struct MicrosoftOneDriveCreatedBy: Codable {
    let user: MicrosoftOneDriveUser
}

struct MicrosoftOneDriveTouchedBy: Codable {
    let user: MicrosoftOneDriveUser
    let application: MicrosoftOneDriveUser?
}

struct MicrosoftOneDriveUser: Codable {
    let displayName: String
    let id: String
}

struct MicrosoftOneDriveParentReference: Codable {
    let driveId: String
    let driveType: String
    let id: String
    let path: String
}

struct MicrosoftOneDriveFileSystemInfo: Codable {
    let createdDateTime: String
    let lastModifiedDateTime: String
}

struct MicrosoftOneDriveFolder: Codable {
    let childCount: Int
    let view: MicrosoftOneDriveView
}

struct MicrosoftOneDriveView: Codable {
    let viewType: String
    let sortBy: String
    let sortOrder: String
}

struct MicrosoftOneDriveSpecialFolder: Codable {
    let name: String
}

struct MicrosoftOneDriveResumableUploadResponse: Codable {
    let uploadUrl: String
    let expirationDateTime: String
    let nextExpectedRanges: [String]
}

// apparently not needed
struct MicrosoftOneDriveResumableUploadRequest: Codable {
    let item: MicrosoftOneDriveResumableUploadItemMetadata
}

// apparently not needed
struct MicrosoftOneDriveResumableUploadItemMetadata: Codable {
    let conflictBehaviour: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case conflictBehaviour = "@microsoft.graph.conflictBehavior"
        case name
    }
}
