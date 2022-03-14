//
//  GoogleDriveEndpoints.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 07/03/2022.
//

import Foundation

enum GoogleDriveEndpoints: Endpoint {
    case uploadFile(resumableURL: String, chunkSize: Int, bytes: String)
    case getResumableUploadURL
    case downloadFile
    case listFiles
    case listFolders
    //
    private var baseURLString: String {
        return "https://www.googleapis.com/upload/drive"
    }
    
    private var authorization: String {
        return "Bearer \(SignedUser.shared.googleAccessToken)"
    }
    //
    var url: String {
        switch self {
        case .getResumableUploadURL:
            return baseURLString + "/v3/files?uploadType=resumable"
        case .uploadFile(let resumableURL, _, _):
            return resumableURL
        case .downloadFile:
            return "TODO"
        case .listFiles:
            return "TODO"
        case .listFolders:
            return "TODO"
        }
    }
    
    var httpMethod: String {
        switch self {
        case .getResumableUploadURL:
            return "POST"
        case .uploadFile:
            return "PUT"
        case .downloadFile:
            return "TODO"
        case .listFiles:
            return "TODO"
        case .listFolders:
            return "TODO"
        }
    }

    var headers: [String: String] {
        switch self {
        case .getResumableUploadURL:
            return ["Authorization": authorization]
        case .uploadFile(_, let chunkSize, let bytes):
            return ["Content-Length": "\(chunkSize)",
                    "Content-Range": "bytes \(bytes)",
                    "Authorization": authorization]
        case .downloadFile:
            return ["Authorization": authorization]
        case .listFiles:
            return ["Authorization": authorization]
        case .listFolders:
            return ["Authorization": authorization]
        }
    }
}
