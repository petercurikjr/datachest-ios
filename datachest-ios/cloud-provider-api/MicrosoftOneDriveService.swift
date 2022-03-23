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
    
    func uploadFileInChunks(chunk: Data, bytes: String, chunkSize: Int, resumableURL: String, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(
            endpoint: MicrosoftOneDriveEndpoints.uploadFileInChunks(resumableURL: resumableURL, chunkSize: chunkSize, bytes: bytes),
            data: chunk
        ) { response in
            completion(response)
        }
    }
    
    func uploadKeyShareFile(file: Data?, fileName: String) {
        NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.uploadKeyShareFile(fileName: fileName), data: file) { _ in }
    }
}
