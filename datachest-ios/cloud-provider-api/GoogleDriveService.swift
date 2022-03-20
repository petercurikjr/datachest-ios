//
//  GoogleDriveService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 26/02/2022.
//

import Foundation

class GoogleDriveService {
    static let shared = GoogleDriveService()
    private init() {}
    
    func getResumableUploadURL(metadata: Data, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: GoogleDriveEndpoints.getResumableUploadURL, data: metadata) { response in
            completion(response)
        }
    }
    
    func uploadFile(chunk: Data, bytes: String, chunkSize: Int, resumableURL: String, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(
            endpoint: GoogleDriveEndpoints.uploadFile(resumableURL: resumableURL, chunkSize: chunkSize, bytes: bytes),
            data: chunk
        ) { response in
            completion(response)
        }
    }
    
    func listFiles(q: String, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: GoogleDriveEndpoints.listFiles(q: q), data: nil) { response in
            completion(response)
        }
    }
    
    func createFolder(metadata: Data, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: GoogleDriveEndpoints.createFolder, data: metadata) { response in
            completion(response)
        }
    }
}
