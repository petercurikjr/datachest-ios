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
    case downloadFile
    case createFolder(parentId: String)
    case getFolderContents(parentId: String)
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
            return baseURLString + "/items/root:/Datachest/Files/\(fileName):/createUploadSession"
        case .uploadFileInChunks(let resumableURL, _, _):
            return resumableURL
        case .uploadKeyShareFile(let fileName):
            return baseURLString + "/items/root:/Datachest/Keys/\(fileName):/content"
        case .downloadFile:
            return "TODO"
        case .createFolder(let parentId):
            return baseURLString + "/items/\(parentId)/children"
        case .getFolderContents(let parentId):
            return baseURLString + "/\(parentId)/children"
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
        case .downloadFile:
            return "TODO"
        case .createFolder:
            return "POST"
        case .getFolderContents:
            return "GET"
        }
    }

    var headers: [String: String] {
        switch self {
        case .createUploadSession:
            return ["Authorization": authorization]
        case .uploadFileInChunks(_, let chunkSize, let bytes):
            return ["Authorization": authorization,
                    "Content-Length": "\(chunkSize)",
                    "Content-Range": "bytes \(bytes)"]
        case .uploadKeyShareFile:
            return ["Authorization": authorization,
                    "Content-Type": "application/json"]
        case .downloadFile:
            return ["Authorization": authorization]
        case .createFolder:
            return ["Authorization": authorization,
                    "Content-Type": "application/json"]
        case .getFolderContents:
            return ["Authorization": authorization]
        }
    }
}

