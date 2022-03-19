//
//  MicrosoftOneDriveService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 14/03/2022.
//

import Foundation

class MicrosoftOneDriveService {
    static let shared = MicrosoftOneDriveService()
    private init() {}
    
    func createUploadSession(fileName: String, fileMetadata: Data?, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.createUploadSession(fileName: fileName), data: fileMetadata) { response in
            completion(response)
        }
    }
    
    func uploadFile(chunk: Data, bytes: String, chunkSize: Int, resumableURL: String, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(
            endpoint: MicrosoftOneDriveEndpoints.uploadFile(resumableURL: resumableURL, chunkSize: chunkSize, bytes: bytes),
            data: chunk
        ) { response in
            completion(response)
        }
    }
    
    /// POTREBUJEME TIETO METODY ??
    func createFolder(parentId: String, folderMetadata: Data, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.createFolder(parentId: parentId), data: folderMetadata) { response in
            completion(response)
        }
    }
    
    func getFolderContents(parentId: String, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.getFolderContents(parentId: parentId), data: nil) { response in
            completion(response)
        }
    }
}
