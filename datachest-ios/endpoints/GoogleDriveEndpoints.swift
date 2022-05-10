//
//  GoogleDriveEndpoints.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 07/03/2022.
//

import Foundation

enum GoogleDriveEndpoints: Endpoint {
    case getAboutData(accessToken: String)
    case uploadKeyShareFile(accessToken: String, resumableURL: String, fileSize: Int)
    case uploadFileInChunks(accessToken: String, resumableURL: String, chunkSize: Int, bytes: String)
    case getResumableUploadURL(accessToken: String)
    case download(accessToken: String, fileId: String)
    case listFiles(accessToken: String, q: GoogleDriveQuery)
    case createFolder(accessToken: String)
    case getFileSize(accessToken: String, fileId: String)
    //
    private var baseURLString: String {
        return "https://www.googleapis.com"
    }
    private var filesURLString: String {
        return "/drive/v3/files"
    }
    //
    var url: String {
        switch self {
        case .getAboutData:
            return baseURLString + "/drive/v2/about"
        case .uploadKeyShareFile(_, let resumableURL, _):
            return resumableURL
        case .getResumableUploadURL:
            return baseURLString + "/upload/drive/v3/files?uploadType=resumable"
        case .uploadFileInChunks(_, let resumableURL, _, _):
            return resumableURL
        case .download(_, let fileId):
            return baseURLString + filesURLString + "/\(fileId)?alt=media"
        case .listFiles(_, let q):
            return baseURLString + filesURLString + q.query
        case .createFolder:
            return baseURLString + filesURLString
        case .getFileSize(_, let fileId):
            return baseURLString + filesURLString + "/\(fileId)?fields=size"
        }
    }
    
    var httpMethod: String {
        switch self {
        case .getAboutData:
            return "GET"
        case .uploadKeyShareFile:
            return "PUT"
        case .getResumableUploadURL:
            return "POST"
        case .uploadFileInChunks:
            return "PUT"
        case .download:
            return "GET"
        case .listFiles:
            return "GET"
        case .createFolder:
            return "POST"
        case .getFileSize:
            return "GET"
        }
    }

    var headers: [String: String] {
        switch self {
        case .getAboutData(let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .uploadKeyShareFile(let accessToken, _, let fileSize):
            return ["Authorization": "Bearer \(accessToken)",
                    "Content-Length": "\(fileSize)"]
        case .getResumableUploadURL(let accessToken):
            return ["Authorization": "Bearer \(accessToken)",
                    "Content-Type": "application/json"]
        case .uploadFileInChunks(let accessToken, _, let chunkSize, let bytes):
            return ["Content-Length": "\(chunkSize)",
                    "Content-Range": "bytes \(bytes)",
                    "Authorization": "Bearer \(accessToken)"]
        case .download(let accessToken, _):
            return ["Authorization": "Bearer \(accessToken)"]
        case .listFiles(let accessToken, _):
            return ["Authorization": "Bearer \(accessToken)"]
        case .createFolder(let accessToken):
            return ["Authorization": "Bearer \(accessToken)",
                    "Content-Type": "application/json"]
        case .getFileSize(let accessToken, _):
            return ["Authorization": "Bearer \(accessToken)"]
        }
    }
}
