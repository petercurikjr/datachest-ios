//
//  GoogleDriveService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 26/02/2022.
//

import GoogleAPIClientForREST
import GTMSessionFetcher
import Foundation

class GoogleDriveService: ObservableObject {
    var gdService: GTLRDriveService?
    
    init() { }
    
    public func setGoogleDriveService(service: GTLRDriveService) {
        self.gdService = service
    }
    
    public func listFiles(folderId: String) {// TODO MOZNO TENTO CALLBACK POUZIT V BUDUCNOSTI, onCompleted: @escaping (GTLRDrive_FileList?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 100
        query.q = "'\(folderId)' in parents and mimeType != 'application/vnd.google-apps.folder'"
        self.gdService?.executeQuery(query) { (ticket, result, error) in
            for i in 0...((result as? GTLRDrive_FileList)?.files!.count)! - 1 {
                print(((result as? GTLRDrive_FileList)?.files![i].name)!)
            }
        }
    }
    
    public func listFolders(folderId: String) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 100
        query.q = "'\(folderId)' in parents and mimeType = 'application/vnd.google-apps.folder'"
        self.gdService?.executeQuery(query) { (ticket, result, error) in
            for i in 0...((result as? GTLRDrive_FileList)?.files!.count)! - 1 {
                print(((result as? GTLRDrive_FileList)?.files![i].name)!)
            }
        }
    }
    
    public func createFolder() {
        
    }
    
    public func uploadFile(url: URL) {
        let file = GTLRDrive_File()
        file.name = url.lastPathComponent
        file.parents = ["root"]
        
        let params = GTLRUploadParameters(fileURL: url, mimeType: "text/plain")
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: params)
        //query.fields = "id"

        self.gdService?.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
            print("upload is in progress.", totalBytesUploaded, "/", totalBytesExpectedToUpload, "bytes uplaoded.")
        }
        
        self.gdService?.executeQuery(query, completionHandler: { (ticket, file, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            print("done")
        })
    }
    
    public func downloadFile() {
        
    }
}
