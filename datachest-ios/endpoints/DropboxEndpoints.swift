//
//  DropboxEndpoints.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation

enum DropboxEndpoints: Endpoint {
    case getCurrentAccount(accessToken: String)
    case getSpaceUsage(accessToken: String)
    case startUploadSession(accessToken: String)
    case uploadFileInChunks(accessToken: String, sessionArg: String)
    case finishUploadSession(accessToken: String, sessionArg: String)
    case uploadKeyShareFile(accessToken: String, uploadArg: String)
    case download(accessToken: String, downloadArg: String)
    case listFiles(accessToken: String)
    case createFolder(accessToken: String)
    //
    private var contentBaseURLString: String {
        return "https://content.dropboxapi.com/2/files"
    }
    private var apiBaseURLString: String {
        return "https://api.dropboxapi.com/2/files"
    }
    private var usersBaseURLString: String {
        return "https://api.dropboxapi.com/2/users"
    }
    //
    var url: String {
        switch self {
        case .getCurrentAccount:
            return usersBaseURLString + "/get_current_account"
        case .getSpaceUsage:
            return usersBaseURLString + "/get_space_usage"
        case .startUploadSession:
            return contentBaseURLString + "/upload_session/start"
        case .uploadFileInChunks:
            return contentBaseURLString + "/upload_session/append_v2"
        case .finishUploadSession:
            return contentBaseURLString + "/upload_session/finish"
        case .uploadKeyShareFile:
            return contentBaseURLString + "/upload"
        case .download:
            return contentBaseURLString + "/download"
        case .listFiles:
            return apiBaseURLString + "/list_folder"
        case .createFolder:
            return apiBaseURLString + "/create_folder_v2"
        }
    }
    
    var httpMethod: String {
        switch self {
        case .getCurrentAccount:
            return "POST"
        case .getSpaceUsage:
            return "POST"
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
            return "POST"
        case .createFolder:
            return "POST"
        }
    }

    var headers: [String: String] {
        switch self {
        case .getCurrentAccount(let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getSpaceUsage(let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .startUploadSession(let accessToken):
            return ["Authorization": "Bearer \(accessToken)",
                    "Content-Type": "application/octet-stream"]
        case .uploadFileInChunks(let accessToken, let sessionArg):
            return ["Authorization": "Bearer \(accessToken)",
                    "Dropbox-API-Arg": sessionArg,
                    "Content-Type": "application/octet-stream"]
        case .finishUploadSession(let accessToken, let sessionArg):
            return ["Authorization": "Bearer \(accessToken)",
                    "Dropbox-API-Arg": sessionArg,
                    "Content-Type": "application/octet-stream"]
        case .uploadKeyShareFile(let accessToken, let uploadArg):
            return ["Authorization": "Bearer \(accessToken)",
                    "Dropbox-API-Arg": uploadArg,
                    "Content-Type": "application/octet-stream"]
        case .download(let accessToken, let downloadArg):
            return ["Authorization": "Bearer \(accessToken)",
                    "Dropbox-API-Arg": downloadArg]
        case .listFiles(let accessToken):
            return ["Authorization": "Bearer \(accessToken)",
                    "Content-Type": "application/json"]
        case .createFolder(let accessToken):
            return ["Authorization": "Bearer \(accessToken)",
                    "Content-Type": "application/json"]
        }
    }
}
