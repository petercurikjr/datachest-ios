//
//  MicrosoftOneDriveEndpoints.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 14/03/2022.
//

import Foundation

enum MicrosoftOneDriveEndpoints: Endpoint {
    case getDriveInfo(accessToken: String)
    case createUploadSession(accessToken: String, fileName: String)
    case uploadFileInChunks(accessToken: String, resumableURL: String, chunkSize: Int, bytes: String)
    case uploadKeyShareFile(accessToken: String, fileName: String)
    case download(accessToken: String, fileId: String)
    case listFiles(accessToken: String)
    case createFolder(accessToken: String, parentFolder: DatachestFolders?)
    //
    private var baseURLString: String {
        return "https://graph.microsoft.com/v1.0/me/drive"
    }
    //
    var url: String {
        switch self {
        case .getDriveInfo:
            return baseURLString
        case .createUploadSession(_, let fileName):
            return baseURLString + "/items/root:\(DatachestFolders.files.full)/\(fileName):/createUploadSession"
        case .uploadFileInChunks(_, let resumableURL, _, _):
            return resumableURL
        case .uploadKeyShareFile(_, let fileName):
            return baseURLString + "/items/root:\(DatachestFolders.keyshareAndMetadata.full)/\(fileName):/content"
        case .download(_, let fileId):
            return baseURLString + "/items/\(fileId)/content"
        case .listFiles:
            return baseURLString + "/root:\(DatachestFolders.files.full):/children"
        case .createFolder(_, let parentFolder):
            let pathArg = "/root" + (parentFolder == nil ? "" : ":/") + (parentFolder?.rawValue ?? "") + (parentFolder == nil ? "" : ":")
            return baseURLString + pathArg + "/children"
        }
    }
    
    var httpMethod: String {
        switch self {
        case .getDriveInfo:
            return "GET"
        case .createUploadSession:
            return "POST"
        case .uploadFileInChunks:
            return "PUT"
        case .uploadKeyShareFile:
            return "PUT"
        case .download:
            return "GET"
        case .listFiles:
            return "GET"
        case .createFolder:
            return "POST"
        }
    }

    var headers: [String: String] {
        switch self {
        case .getDriveInfo(let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .createUploadSession(let accessToken, _):
            return ["Authorization": "Bearer \(accessToken)",
                    "Content-Type": "application/json"]
        case .uploadFileInChunks(let accessToken, _, let chunkSize, let bytes):
            return ["Authorization": "Bearer \(accessToken)",
                    "Content-Length": "\(chunkSize)",
                    "Content-Range": "bytes \(bytes)"]
        case .uploadKeyShareFile(let accessToken, _):
            return ["Authorization": "Bearer \(accessToken)",
                    "Content-Type": "application/json"]
        case .download(let accessToken, _):
            return ["Authorization": "Bearer \(accessToken)"]
        case .listFiles(let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .createFolder(let accessToken, _):
            return ["Authorization": "Bearer \(accessToken)",
                    "Content-Type": "application/json"]
        }
    }
}

