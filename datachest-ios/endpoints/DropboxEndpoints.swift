//
//  DropboxEndpoints.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation

enum DropboxEndpoints: Endpoint {
    case startUploadSession
    case uploadFileInChunks(sessionArg: String)
    case finishUploadSession(sessionArg: String)
    case uploadKeyShareFile(uploadArg: String)
    case download(downloadArg: String)
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
        case .uploadFileInChunks:
            return baseURLString + "/upload_session/append_v2"
        case .finishUploadSession:
            return baseURLString + "/upload_session/finish"
        case .uploadKeyShareFile:
            return baseURLString + "/upload"
        case .download:
            return baseURLString + "/download"
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
        case .uploadFileInChunks:
            return "POST"
        case .finishUploadSession:
            return "POST"
        case .uploadKeyShareFile:
            return "POST"
        case .download:
            return "POST"
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
        case .uploadFileInChunks(let sessionArg):
            return ["Authorization": authorization,
                    "Dropbox-API-Arg": sessionArg,
                    "Content-Type": "application/octet-stream"]
        case .finishUploadSession(let sessionArg):
            return ["Authorization": authorization,
                    "Dropbox-API-Arg": sessionArg,
                    "Content-Type": "application/octet-stream"]
        case .uploadKeyShareFile(let uploadArg):
            return ["Authorization": authorization,
                    "Dropbox-API-Arg": uploadArg,
                    "Content-Type": "application/octet-stream"]
        case .download(let downloadArg):
            return ["Authorization": authorization,
                    "Dropbox-API-Arg": downloadArg]
        case .listFiles:
            return ["Authorization": authorization]
        case .listFolders:
            return ["Authorization": authorization]
        }
    }
}
