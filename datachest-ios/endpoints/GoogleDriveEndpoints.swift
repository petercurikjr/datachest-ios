//
//  GoogleDriveEndpoints.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 07/03/2022.
//

import Foundation

enum GoogleDriveEndpoints: Endpoint {
    case uploadKeyShareFile(resumableURL: String, fileSize: Int)
    case uploadFileInChunks(resumableURL: String, chunkSize: Int, bytes: String)
    case getResumableUploadURL
    case downloadFile
    case listFiles(q: String)
    case createFolder
    //
    private var baseURLString: String {
        return "https://www.googleapis.com"
    }
    
    private var authorization: String {
        return "Bearer \(SignedUser.shared.googleAccessToken)"
    }
    //
    var url: String {
        switch self {
        case .uploadKeyShareFile(let resumableURL, _):
            return resumableURL
        case .getResumableUploadURL:
            return baseURLString + "/upload/drive/v3/files?uploadType=resumable"
        case .uploadFileInChunks(let resumableURL, _, _):
            return resumableURL
        case .downloadFile:
            return "TODO"
        case .listFiles(let q):
            return baseURLString + "/drive/v3/files" + q
        case .createFolder:
            return baseURLString + "/drive/v3/files"
        }
    }
    
    var httpMethod: String {
        switch self {
        case .uploadKeyShareFile:
            return "PUT"
        case .getResumableUploadURL:
            return "POST"
        case .uploadFileInChunks:
            return "PUT"
        case .downloadFile:
            return "TODO"
        case .listFiles:
            return "GET"
        case .createFolder:
            return "POST"
        }
    }

    var headers: [String: String] {
        switch self {
        case .uploadKeyShareFile(_, let fileSize):
            return ["Authorization": authorization,
                    "Content-Length": "\(fileSize)"]
        case .getResumableUploadURL:
            return ["Authorization": authorization,
                    "Content-Type": "application/json"]
        case .uploadFileInChunks(_, let chunkSize, let bytes):
            return ["Content-Length": "\(chunkSize)",
                    "Content-Range": "bytes \(bytes)",
                    "Authorization": authorization]
        case .downloadFile:
            return ["Authorization": authorization]
        case .listFiles:
            return ["Authorization": authorization]
        case .createFolder:
            return ["Authorization": authorization,
                    "Content-Type": "application/json"]
        }
    }
}
