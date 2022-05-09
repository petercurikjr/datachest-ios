//
//  GoogleDriveModel.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 20/03/2022.
//

import Foundation

struct GoogleDriveAboutResponse: Codable {
    let name: String
    let quotaBytesTotal: String
    let quotaBytesUsed: String
    let quotaType: GoogleDriveQuotaType
}

struct GoogleDriveListFilesResponse: Codable {
    let files: [GoogleDriveFileResponse]
}

struct GoogleDriveFileSize: Codable {
    let size: String
}

struct GoogleDriveFileResponse: Codable, Identifiable {
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

enum GoogleDriveQuotaType: String, Codable {
    case limited = "LIMITED"
    case unlimited = "UNLIMITED"
}

enum GoogleDriveItemMimeType: String, Codable {
    case folder = "application/vnd.google-apps.folder"
    case file = "application/octet-stream"
}

enum GoogleDriveQuery {
    case getFolder(folderName: DatachestFolders, parentId: String?)
    case listItemsInFilesFolder(folderId: String)
    
    var query: String {
        switch self {
        case .getFolder(let folderName, let parentId):
            return "?q=name+%3d+%27\(folderName.rawValue)%27+and+mimeType+%3d+%27\(GoogleDriveItemMimeType.folder.rawValue)%27+and+trashed+%3d+false" + (parentId != nil ? "+and+%27\(parentId!)%27+in+parents" : "")
        case .listItemsInFilesFolder(let folderId):
            return "?q=%27\(folderId)%27+in+parents"
        }
    }
}

