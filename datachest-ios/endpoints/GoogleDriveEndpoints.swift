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
    case download(fileId: String)
    case listFiles(q: GoogleDriveQuery)
    case createFolder
    case getFileSize(fileId: String)
    //
    private var baseURLString: String {
        return "https://www.googleapis.com"
    }
    private var filesURLString: String {
        return "/drive/v3/files"
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
        case .download(let fileId):
            return baseURLString + filesURLString + "/\(fileId)?alt=media"
        case .listFiles(let q):
            return baseURLString + filesURLString + q.query
        case .createFolder:
            return baseURLString + filesURLString
        case .getFileSize(let fileId):
            return baseURLString + filesURLString + "/\(fileId)?fields=size"
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
        case .download:
            return ["Authorization": authorization]
        case .listFiles:
            return ["Authorization": authorization]
        case .createFolder:
            return ["Authorization": authorization,
                    "Content-Type": "application/json"]
        case .getFileSize:
            return ["Authorization": authorization]
        }
    }
}
