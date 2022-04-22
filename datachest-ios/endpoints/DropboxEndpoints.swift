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
    case createFolder
    //
    private var contentBaseURLString: String {
        return "https://content.dropboxapi.com/2/files"
    }
    private var apiBaseURLString: String {
        return "https://api.dropboxapi.com/2/files"
    }
    
    private var authorization: String {
        return "Bearer " + self.getAccessToken()
    }
    //
    var url: String {
        switch self {
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
            return ["Authorization": authorization,
                    "Content-Type": "application/json"]
        case .createFolder:
            return ["Authorization": authorization,
                    "Content-Type": "application/json"]
        }
    }
    
    private func getAccessToken() -> String {
        if let keychainItem = KeychainHelper.shared.loadFromKeychain(service: "datachest-auth-keychain-itemf", account: "dropbox"),
           let object = try? JSONDecoder().decode(DatachestDropboxAuthKeychainItem.self, from: keychainItem) {
            let dateNow = Date()
            let diffMinutes = (Int(dateNow.timeIntervalSince1970 - object.accessTokenExpirationDate.timeIntervalSince1970)) / 60
            if diffMinutes < 5 {
                DropboxAuthService.shared.signInDropboxSilently()
            }
        }
        
        return ApplicationStore.shared.state.dropboxAccessToken
    }
}
