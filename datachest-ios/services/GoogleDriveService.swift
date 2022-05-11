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
    
    private func getAccessToken(completion: @escaping (String) -> Void) {
        if !GoogleAuthService.shared.isTokenValid() {
            GoogleAuthService.shared.signInGoogleSilently {
                completion(ApplicationStore.shared.state.googleAccessToken)
            }
        }
        else if ApplicationStore.shared.state.googleAccessToken != "" {
            completion(ApplicationStore.shared.state.googleAccessToken)
        }
    }
    
    func getAboutData(completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: GoogleDriveEndpoints.getAboutData(accessToken: token), data: nil) { response in
                completion(response)
            }
        }
    }
    
    func getResumableUploadURL(metadata: Data, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: GoogleDriveEndpoints.getResumableUploadURL(accessToken: token), data: metadata) { response in
                completion(response)
            }
        }
    }
    
    func uploadFileInChunks(chunk: Data, bytes: String, chunkSize: Int, resumableURL: String, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(
                endpoint: GoogleDriveEndpoints.uploadFileInChunks(accessToken: token, resumableURL: resumableURL, chunkSize: chunkSize, bytes: bytes),
                data: chunk
            ) { response in
                completion(response)
            }
        }
    }
    
    func uploadKeyShareFile(file: Data?, resumableURL: String, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(
                endpoint: GoogleDriveEndpoints.uploadKeyShareFile(accessToken: token, resumableURL: resumableURL, fileSize: file?.count ?? 0),
                data: file
            ) { response in
                completion(response)
            }
        }
    }
    
    func listFiles(q: GoogleDriveQuery, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: GoogleDriveEndpoints.listFiles(accessToken: token, q: q), data: nil) { response in
                completion(response)
            }
        }
    }
    
    func createFolder(metadata: Data, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: GoogleDriveEndpoints.createFolder(accessToken: token), data: metadata) { response in
                completion(response)
            }
        }
    }
    
    func getFileSize(fileId: String, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: GoogleDriveEndpoints.getFileSize(accessToken: token, fileId: fileId), data: nil) { response in
                completion(response)
            }
        }
    }
    
    func downloadKeyShare(shareId: String, completion: @escaping (NetworkResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.request(endpoint: GoogleDriveEndpoints.download(accessToken: token, fileId: shareId), data: nil) { response in
                completion(response)
            }
        }
    }
    
    func downloadFile(fileId: String, ongoingDownloadId: Int?, completion: @escaping (DownloadResponse) -> Void) {
        self.getAccessToken { token in
            NetworkService.shared.download(endpoint: GoogleDriveEndpoints.download(accessToken: token, fileId: fileId), ongoingDownloadId: ongoingDownloadId) { response in
                completion(response)
            }
        }
    }
}
