//
//  DropboxFacade.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation

class DropboxFacade {
    static let shared = DropboxFacade()
    var activeUploadSessions: [DropboxFileUploadSession] = []

    private init() {}

    func uploadFile(fileUrl: URL) {
        activeUploadSessions.append(DropboxFileUploadSession(fileUrl: fileUrl))
    }
    
    func listFilesOnCloud(completion: @escaping ([DropboxFileResponse]) -> Void) {
        let ccd = CommonCloudContainer()
        ccd.dropboxCheckOrCreateAllFolders() {
            let dataArg = DropboxListFilesRequest(path: DatachestFolders.files.full, include_deleted: false)
            if let jsonData = try? JSONEncoder().encode(dataArg) {
                DropboxService.shared.listFiles(dataArg: jsonData) { response in
                    guard let files = try? JSONDecoder().decode(DropboxListFilesResponse.self, from: response.data) else {
                        DispatchQueue.main.async {
                            ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                        }
                        return
                    }
                    completion(files.entries)
                }
            }
        }
    }
}
