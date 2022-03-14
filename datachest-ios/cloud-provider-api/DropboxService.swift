//
//  DropboxService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation

class DropboxService: NetworkService {
    static let shared = DropboxService()
    private override init() { super.init() }
    
    func startUploadSession(completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        self.request(endpoint: DropboxEndpoints.startUploadSession, data: nil) { data, response, error in
            completion(data, response, error)
        }
    }
    
    func uploadFile(chunk: Data, sessionArg: String, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        self.request(endpoint: DropboxEndpoints.uploadFile(sessionArg: sessionArg), data: chunk) { data, response, error in
            completion(data, response, error)
        }
    }
    
    func finishUploadSession(chunk: Data, sessionArg: String, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        self.request(endpoint: DropboxEndpoints.finishUploadSession(sessionArg: sessionArg), data: chunk) { data, response, error in
            completion(data, response, error )
        }
    }
}
