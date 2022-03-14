//
//  DropboxEndpoints.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation

enum DropboxEndpoints: Endpoint {
    case startUploadSession
    case uploadFile(sessionArg: String)
    case finishUploadSession(sessionArg: String)
    case downloadFile
    case listFiles
    case listFolders
    //
    private var baseURLString: String {
        return "https://content.dropboxapi.com/2/files"
    }
    
    private var authorization: String {
        return "Bearer \(SignedUser.shared.dropboxAccessToken)"
    }
    //
    var url: String {
        switch self {
        case .startUploadSession:
            return baseURLString + "/upload_session/start"
        case .uploadFile:
            return baseURLString + "/upload_session/append_v2"
        case .finishUploadSession:
            return baseURLString + "/upload_session/finish"
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
        case .startUploadSession:
            return "POST"
        case .uploadFile:
            return "POST"
        case .finishUploadSession:
            return "POST"
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
        case .startUploadSession:
            return ["Authorization": authorization,
                    "Content-Type": "application/octet-stream"]
        case .uploadFile(let sessionArg):
            return ["Authorization": authorization,
                    "Dropbox-API-Arg": sessionArg,
                    "Content-Type": "application/octet-stream"]
        case .finishUploadSession(let sessionArg):
            return ["Authorization": authorization,
                    "Dropbox-API-Arg": sessionArg,
                    "Content-Type": "application/octet-stream"]
        case .downloadFile:
            return ["Authorization": authorization]
        case .listFiles:
            return ["Authorization": authorization]
        case .listFolders:
            return ["Authorization": authorization]
        }
    }
}
