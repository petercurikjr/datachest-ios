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
    
    func startUploadSession(completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: DropboxEndpoints.startUploadSession, data: nil) { response in
            completion(response)
        }
    }
    
    func uploadFileInChunks(chunk: Data, sessionArg: String, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: DropboxEndpoints.uploadFileInChunks(sessionArg: sessionArg), data: chunk) { response in
            completion(response)
        }
    }
    
    func finishUploadSession(chunk: Data, sessionArg: String, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: DropboxEndpoints.finishUploadSession(sessionArg: sessionArg), data: chunk) { response in
            completion(response)
        }
    }
    
    func uploadKeyShareFile(file: Data?, uploadArg: String) {
        NetworkService.shared.request(endpoint: DropboxEndpoints.uploadKeyShareFile(uploadArg: uploadArg), data: file) { _ in }
    }
}