//
//  MicrosoftOneDriveService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 14/03/2022.
//

import Foundation

class MicrosoftOneDriveService: NetworkService {
    static let shared = MicrosoftOneDriveService()
    private override init() { super.init() }
    
    func createUploadSession(fileName: String, fileMetadata: Data?, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        self.request(endpoint: MicrosoftOneDriveEndpoints.createUploadSession(fileName: fileName), data: fileMetadata) { data, response, error in
            completion(data, response, error)
        }
    }
    
    func uploadFile(chunk: Data, bytes: String, chunkSize: Int, resumableURL: String, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        self.request(
            endpoint: MicrosoftOneDriveEndpoints.uploadFile(resumableURL: resumableURL, chunkSize: chunkSize, bytes: bytes),
            data: chunk
        ) { data, response, error in
            completion(data, response, error)
        }
    }
    
    func createFolder(parentId: String, folderMetadata: Data, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        self.request(endpoint: MicrosoftOneDriveEndpoints.createFolder(parentId: parentId), data: folderMetadata) { data, response, error in
            completion(data, response, error)
        }
    }
    
    func getFolderContents(parentId: String, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        self.request(endpoint: MicrosoftOneDriveEndpoints.getFolderContents(parentId: parentId), data: nil) { data, response, error in
            completion(data, response, error)
        }
    }
}
