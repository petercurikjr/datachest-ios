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
    
    private func getAccessToken(completion: @escaping (String) -> Void) {
        if !MicrosoftAuthService.shared.isTokenValid() {
            MicrosoftAuthService.shared.signInMicrosoftSilently {
                completion(ApplicationStore.shared.state.microsoftAccessToken)
            }
        }
        else if ApplicationStore.shared.state.microsoftAccessToken != "" {
            completion(ApplicationStore.shared.state.microsoftAccessToken)
        }
    }
    
    func getDriveInfo(completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.getDriveInfo(accessToken: token), data: nil) { response in
                completion(response)
            }
        }
    }
    
    func createUploadSession(fileName: String, fileMetadata: Data?, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.createUploadSession(accessToken: token, fileName: fileName), data: fileMetadata) { response in
                completion(response)
            }
        }
    }
    
    func uploadFileInChunks(chunk: Data, bytes: String, chunkSize: Int, resumableURL: String, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(
                endpoint: MicrosoftOneDriveEndpoints.uploadFileInChunks(accessToken: token, resumableURL: resumableURL, chunkSize: chunkSize, bytes: bytes),
                data: chunk
            ) { response in
                completion(response)
            }
        }
    }
    
    func uploadKeyShareFile(file: Data?, fileName: String, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.uploadKeyShareFile(accessToken: token, fileName: fileName), data: file) { response in
                completion(response)
            }
        }
    }
    
    func downloadKeyShare(shareId: String, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.download(accessToken: token, fileId: shareId), data: nil) { response in
                completion(response)
            }
        }
    }
    
    func downloadFile(fileId: String, ongoingDownloadId: Int?, completion: @escaping (DownloadResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.download(endpoint: MicrosoftOneDriveEndpoints.download(accessToken: token, fileId: fileId), ongoingDownloadId: ongoingDownloadId) { response in
                completion(response)
            }
        }
    }
    
    func listFiles(completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.listFiles(accessToken: token), data: nil) { response in
                completion(response)
            }
        }
    }
    
    func createFolder(parentFolder: DatachestFolders?, data: Data, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: MicrosoftOneDriveEndpoints.createFolder(accessToken: token, parentFolder: parentFolder), data: data) { response in
                completion(response)
            }
        }
    }
}
