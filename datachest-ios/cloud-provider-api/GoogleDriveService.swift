//
//  GoogleDriveService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 26/02/2022.
//

import Foundation

class GoogleDriveService: NetworkService {
    static let shared = GoogleDriveService()
    private override init() { super.init() }
    
    func getResumableUploadURL(completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        self.request(endpoint: GoogleDriveEndpoints.getResumableUploadURL, data: nil) { data, response, error in
            completion(data, response, error)
        }
    }
    
    func uploadFile(chunk: Data, bytes: String, chunkSize: Int, resumableURL: String, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        self.request(
            endpoint: GoogleDriveEndpoints.uploadFile(resumableURL: resumableURL, chunkSize: chunkSize, bytes: bytes),
            data: chunk
        ) { data, response, error in
            completion(data, response, error)
        }
    }
}
