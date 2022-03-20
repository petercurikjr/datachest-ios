//
//  GoogleDriveModel.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 20/03/2022.
//

import Foundation

enum GoogleDriveItemMimeType: String, Codable {
    case folder = "application/vnd.google-apps.folder"
    case file = "application/octet-stream"
}

struct GoogleDriveListFilesResponse: Codable {
    let files: [GoogleDriveFileResponse]
}

struct GoogleDriveFileResponse: Codable {
    let kind: String
    let id: String
    let name: String
    let mimeType: String
}

struct GoogleDriveCreateItemMetadata: Codable {
    let name: String
    let mimeType: String
    let parents: [String]?
}

