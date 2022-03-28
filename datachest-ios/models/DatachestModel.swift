//
//  DatachestModel.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 21/03/2022.
//

import Foundation

struct DatachestKeyShareFile: Codable {
    let keyShare: String
    let mappedFileData: DatachestMappedFileData?
}

struct DatachestMappedFileData: Codable {
    let fileId: String
    let aesTag: [Data]
    let aesNonce: String
}

enum DatachestSupportedClouds: String {
    case microsoft = "Microsoft OneDrive"
    case google = "Google Drive"
    case dropbox = "Dropbox"
    
    static let allValues = [microsoft, google, dropbox]
}

enum DatachestFolders: String {
    case root = "Datachest"
    case files = "Files"
    case keyshareAndMetadata = "Keys"
    
    var full: String {
        switch self {
        case .root:
            return "/Datachest"
        case .files:
            return "/Datachest/Files"
        case .keyshareAndMetadata:
            return "/Datachest/Keys"
        }
    }
}
