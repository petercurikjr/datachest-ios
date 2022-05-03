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
    
    func getDriveInfo(completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.getDriveInfo, data: nil) { response in
            completion(response)
        }
    }
    
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
    
    func uploadKeyShareFile(file: Data?, fileName: String, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.uploadKeyShareFile(fileName: fileName), data: file) { response in
            completion(response)
        }
    }
    
    func downloadKeyShare(shareId: String, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.download(fileId: shareId), data: nil) { response in
            completion(response)
        }
    }
    
    func downloadFile(fileId: String, completion: @escaping (DownloadResponse) -> Void) {
        NetworkService.shared.download(endpoint: MicrosoftOneDriveEndpoints.download(fileId: fileId)) { response in
            completion(response)
        }
    }
    
    func listFiles(completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.listFiles, data: nil) { response in
            completion(response)
        }
    }
    
    func createFolder(parentFolder: DatachestFolders?, data: Data, completion: @escaping (NetworkResponse) -> Void) {
        NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.createFolder(parentFolder: parentFolder), data: data) { response in
            completion(response)
        }
    }
}
