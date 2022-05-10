//
//  DropboxService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation

class DropboxService {
    static let shared = DropboxService()
    private init() {}
    
    private func getAccessToken(completion: @escaping (String) -> Void) {
        if !DropboxAuthService.shared.isTokenValid() {
            DropboxAuthService.shared.signInDropboxSilently {
                completion(ApplicationStore.shared.state.dropboxAccessToken)
            }
        }
        else {
            completion(ApplicationStore.shared.state.dropboxAccessToken)
        }
    }
    
    func getCurrentAccount(completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: DropboxEndpoints.getCurrentAccount(accessToken: token), data: nil) { response in
                completion(response)
            }
        }
    }
    
    func getSpaceUsage(completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: DropboxEndpoints.getSpaceUsage(accessToken: token), data: nil) { response in
                completion(response)
            }
        }
    }
    
    func startUploadSession(completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: DropboxEndpoints.startUploadSession(accessToken: token), data: nil) { response in
                completion(response)
            }
        }
    }
    
    func uploadFileInChunks(chunk: Data, sessionArg: String, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: DropboxEndpoints.uploadFileInChunks(accessToken: token, sessionArg: sessionArg), data: chunk) { response in
                completion(response)
            }
        }
    }
    
    func finishUploadSession(chunk: Data, sessionArg: String, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: DropboxEndpoints.finishUploadSession(accessToken: token, sessionArg: sessionArg), data: chunk) { response in
                completion(response)
            }
        }
    }
    
    func uploadKeyShareFile(file: Data?, uploadArg: String, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: DropboxEndpoints.uploadKeyShareFile(accessToken: token, uploadArg: uploadArg), data: file) { response in
                completion(response)
            }
        }
    }
    
    func downloadKeyShare(downloadArg: String, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: DropboxEndpoints.download(accessToken: token, downloadArg: downloadArg), data: nil) { response in
                completion(response)
            }
        }
    }
    
    func downloadFile(downloadArg: String, completion: @escaping (DownloadResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.download(endpoint: DropboxEndpoints.download(accessToken: token, downloadArg: downloadArg)) { response in
                completion(response)
            }
        }
    }
    
    func listFiles(dataArg: Data, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: DropboxEndpoints.listFiles(accessToken: token), data: dataArg) { response in
                completion(response)
            }
        }
    }
    
    func createFolder(dataArg: Data, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: DropboxEndpoints.createFolder(accessToken: token), data: dataArg) { response in
                completion(response)
            }
        }
    }
}
