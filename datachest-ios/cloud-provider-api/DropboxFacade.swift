//
//  DropboxFacade.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation

class DropboxFacade {
    static let shared = DropboxFacade()

    private init() {}

    func getCurrentAccount(completion: @escaping (DropboxCurrentAccountResponse) -> Void) {
        DropboxService.shared.getCurrentAccount { response in
            guard let account = try? JSONDecoder().decode(DropboxCurrentAccountResponse.self, from: response.data) else {
                DispatchQueue.main.async {
                    if ApplicationStore.shared.uistate.error == nil {
                        ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                    }
                }
                return
            }
            completion(account)
        }
    }
    
    func getSpaceUsage(completion: @escaping (DropboxSpaceUsageResponse) -> Void) {
        DropboxService.shared.getSpaceUsage { response in
            guard let spaceUsage = try? JSONDecoder().decode(DropboxSpaceUsageResponse.self, from: response.data) else {
                DispatchQueue.main.async {
                    if ApplicationStore.shared.uistate.error == nil {
                        ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                    }
                }
                return
            }
            completion(spaceUsage)
        }
    }
    
    func uploadFile(fileUrl: URL) {
        let _ = DropboxFileUploadSession(fileUrl: fileUrl)
    }
    
    func downloadFile(file: DropboxFileResponse) {
        let dpb = DropboxFileDownloadSession(fileId: file.id, fileName: file.name)
        let ongoingDownload = DatachestOngoingFileTransfer(
            id: ApplicationStore.shared.uistate.ongoingDownloads.count,
            owner: DatachestSupportedClouds.dropbox,
            fileName: file.name
        )
        DispatchQueue.main.async {
            ApplicationStore.shared.uistate.ongoingDownloads.append(ongoingDownload)
        }
        dpb.ongoingDownload = ongoingDownload
        dpb.downloadFile()
    }
    
    func listFilesOnCloud(completion: @escaping ([DropboxFileResponse]) -> Void) {
        let ccd = CommonCloudContainer()
        ccd.dropboxCheckOrCreateAllFolders() {
            let dataArg = DropboxListFilesRequest(path: DatachestFolders.files.full, include_deleted: false)
            if let jsonData = try? JSONEncoder().encode(dataArg) {
                DropboxService.shared.listFiles(dataArg: jsonData) { response in
                    guard let files = try? JSONDecoder().decode(DropboxListFilesResponse.self, from: response.data) else {
                        DispatchQueue.main.async {
                            if ApplicationStore.shared.uistate.error == nil {
                                ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                            }
                        }
                        return
                    }
                    completion(files.entries)
                }
            }
        }
    }
}
