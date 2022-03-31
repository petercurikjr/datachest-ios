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
    
    func uploadFileInChunks(chunk: Data, bytes: String, chunkSize: Int, resumableURL: String, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(
            endpoint: GoogleDriveEndpoints.uploadFileInChunks(resumableURL: resumableURL, chunkSize: chunkSize, bytes: bytes),
            data: chunk
        ) { response in
            completion(response)
        }
    }
    
    func uploadKeyShareFile(file: Data?, resumableURL: String, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(
            endpoint: GoogleDriveEndpoints.uploadKeyShareFile(resumableURL: resumableURL, fileSize: file?.count ?? 0),
            data: file
        ) { response in
            completion(response)
        }
    }
    
    func listFiles(q: GoogleDriveQuery, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: GoogleDriveEndpoints.listFiles(q: q), data: nil) { response in
            completion(response)
        }
    }
    
    func createFolder(metadata: Data, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: GoogleDriveEndpoints.createFolder, data: metadata) { response in
            completion(response)
        }
    }
    
    func getFileSize(fileId: String, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: GoogleDriveEndpoints.getFileSize(fileId: fileId), data: nil) { response in
            completion(response)
        }
    }
    
    func downloadKeyShare(shareId: String, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: GoogleDriveEndpoints.download(fileId: shareId), data: nil) { response in
            completion(response)
        }
    }
    
    func downloadFile(fileId: String, completion: @escaping (DownloadResponse) -> Void) {
        NetworkService.shared.download(endpoint: GoogleDriveEndpoints.download(fileId: fileId)) { response in
            completion(response)
        }
    }
}
