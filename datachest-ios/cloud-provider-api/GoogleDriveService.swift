//
//  GoogleDriveService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 26/02/2022.
//

import Foundation

class GoogleDriveService {
    static let shared = GoogleDriveService()
    private init() { }
    
    func getResumableUploadURL(completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        request(endpoint: GoogleDriveEndpoints.getResumableUploadURL, data: nil) { data, response, error in
            completion(data, response, error)
        }
    }
    
    func uploadLargeFile(chunk: Data, bytes: String, chunkSize: Int, resumableURL: String, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        self.request(
            endpoint: GoogleDriveEndpoints.uploadLargeFile(resumableURL: resumableURL, chunkSize: chunkSize, bytes: bytes),
            data: chunk
        ) { data, response, error in
            completion(data, response, error)
        }
    }
    
    private func request(endpoint: Endpoint, data: Data?, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: endpoint.url)!)
        request.httpMethod = endpoint.httpMethod
        endpoint.headers.forEach({ header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        })
        request.httpBody = data
        
        if data != nil {
            let task = URLSession.shared.uploadTask(with: request, from: data!) { data, response, error in
                completion(data, response as? HTTPURLResponse, error)
            }

            task.resume()
        }
        
        else {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                completion(data, response as? HTTPURLResponse, error)
            }

            task.resume()
        }
    }
}













//    public func setGoogleDriveService(service: GTLRDriveService) {
//        self.gdService = service
//    }
//
//    public func listFiles(folderId: String) {// TODO MOZNO TENTO CALLBACK POUZIT V BUDUCNOSTI, onCompleted: @escaping (GTLRDrive_FileList?, Error?) -> ()) {
//        let query = GTLRDriveQuery_FilesList.query()
//        query.pageSize = 100
//        query.q = "'\(folderId)' in parents and mimeType != 'application/vnd.google-apps.folder'"
//        self.gdService?.executeQuery(query) { (ticket, result, error) in
//            for i in 0...((result as? GTLRDrive_FileList)?.files!.count)! - 1 {
//                print(((result as? GTLRDrive_FileList)?.files![i].name)!)
//            }
//        }
//    }
//
//    public func listFolders(folderId: String) {
//        let query = GTLRDriveQuery_FilesList.query()
//        query.pageSize = 100
//        query.q = "'\(folderId)' in parents and mimeType = 'application/vnd.google-apps.folder'"
//        self.gdService?.executeQuery(query) { (ticket, result, error) in
//            for i in 0...((result as? GTLRDrive_FileList)?.files!.count)! - 1 {
//                print(((result as? GTLRDrive_FileList)?.files![i].name)!)
//            }
//        }
//    }
//
//    public func uploadFile(url: URL) {
//        let file = GTLRDrive_File()
//        file.name = url.lastPathComponent
//        file.parents = ["root"]
//
//        let params = GTLRUploadParameters(fileURL: url, mimeType: "text/plain")
//
//        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: params)
//        //query.fields = "id"
//
//        self.gdService?.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
//            print("upload is in progress.", totalBytesUploaded, "/", totalBytesExpectedToUpload, "bytes uplaoded.")
//        }
//
//        self.gdService?.executeQuery(query, completionHandler: { (ticket, file, error) in
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//            print("done")
//        })
//    }
