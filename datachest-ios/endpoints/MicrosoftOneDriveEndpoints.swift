//
//  MicrosoftOneDriveEndpoints.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 14/03/2022.
//

import Foundation

enum MicrosoftOneDriveEndpoints: Endpoint {
    case createUploadSession(fileName: String)
    case uploadFileInChunks(resumableURL: String, chunkSize: Int, bytes: String)
    case uploadKeyShareFile(fileName: String)
    case download(fileId: String)
    case listFiles
    case createFolder(parentFolder: DatachestFolders?)
    //
    private var baseURLString: String {
        return "https://graph.microsoft.com/v1.0/me/drive"
    }
    
    private var authorization: String {
        return "Bearer \(SignedUser.shared.microsoftAccessToken)"
    }
    //
    var url: String {
        switch self {
        case .createUploadSession(let fileName):
            return baseURLString + "/items/root:\(DatachestFolders.files.full)/\(fileName):/createUploadSession"
        case .uploadFileInChunks(let resumableURL, _, _):
            return resumableURL
        case .uploadKeyShareFile(let fileName):
            return baseURLString + "/items/root:\(DatachestFolders.keyshareAndMetadata.full)/\(fileName):/content"
        case .download(let fileId):
            return baseURLString + "/items/\(fileId)/content"
        case .listFiles:
            return baseURLString + "/root:\(DatachestFolders.files.full):/children"
        case .createFolder(let parentFolder):
            let pathArg = "/root" + (parentFolder == nil ? "" : ":/") + (parentFolder?.rawValue ?? "") + (parentFolder == nil ? "" : ":")
            return baseURLString + pathArg + "/children"
        }
    }
    
    var httpMethod: String {
        switch self {
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
        case .createUploadSession:
            return ["Authorization": authorization,
                    "Content-Type": "application/json"]
        case .uploadFileInChunks(_, let chunkSize, let bytes):
            return ["Authorization": authorization,
                    "Content-Length": "\(chunkSize)",
                    "Content-Range": "bytes \(bytes)"]
        case .uploadKeyShareFile:
            return ["Authorization": authorization,
                    "Content-Type": "application/json"]
        case .download:
            return ["Authorization": authorization]
        case .listFiles:
            return ["Authorization": authorization]
        case .createFolder:
            return ["Authorization": authorization,
                    "Content-Type": "application/json"]
        }
    }
}

