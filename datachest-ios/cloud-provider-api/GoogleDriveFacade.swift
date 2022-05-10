//
//  GoogleDriveFacade.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 08/03/2022.
//

import Foundation

class GoogleDriveFacade {
    static let shared = GoogleDriveFacade()
    
    private init() {}
    
    func getAboutData(completion: @escaping (GoogleDriveAboutResponse) -> Void) {
        GoogleDriveService.shared.getAboutData { response in
            guard let aboutInfo = try? JSONDecoder().decode(GoogleDriveAboutResponse.self, from: response.data) else {
                DispatchQueue.main.async {
                    if ApplicationStore.shared.uistate.error == nil {
                        ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                    }
                }
                return
            }
            completion(aboutInfo)
        }
    }
    
    func uploadFile(fileUrl: URL) {
        let _ = GoogleDriveFileUploadSession(fileUrl: fileUrl) { closureGd in
            closureGd.createNewUploadSession(destinationFolder: .files, fileName: nil) { _ in
                let ongoingUpload = DatachestOngoingFileTransfer(
                    id: ApplicationStore.shared.uistate.ongoingUploads.count,
                    owner: DatachestSupportedClouds.google,
                    fileName: closureGd.fileName
                )
                DispatchQueue.main.async {
                    ApplicationStore.shared.uistate.ongoingUploads.append(ongoingUpload)
                }
                closureGd.ongoingUpload = ongoingUpload
                closureGd.uploadFile()
            }
        }
    }
    
    func downloadFile(file: GoogleDriveFileResponse) {
        let gd = GoogleDriveFileDownloadSession(fileId: file.id, fileName: file.name)
        let ongoingDownload = DatachestOngoingFileTransfer(
            id: ApplicationStore.shared.uistate.ongoingDownloads.count,
            owner: DatachestSupportedClouds.google,
            fileName: file.name
        )
        DispatchQueue.main.async {
            ApplicationStore.shared.uistate.ongoingDownloads.append(ongoingDownload)
        }
        gd.ongoingDownload = ongoingDownload
        gd.downloadFile()
    }
    
    func listFilesOnCloud(completion: @escaping ([GoogleDriveFileResponse]) -> Void) {
        let ccd = CommonCloudContainer()
        ccd.googleDriveGetOrCreateAllFolders() {
            GoogleDriveService.shared.listFiles(
                q: .listItemsInFilesFolder(
                    folderId: ApplicationStore.shared.state.googleDriveFolderIds[.files] ?? ""
                )
            ) { response in
                guard let files = try? JSONDecoder().decode(GoogleDriveListFilesResponse.self, from: response.data) else {
                    DispatchQueue.main.async {
                        if ApplicationStore.shared.uistate.error == nil {
                            ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                        }
                    }
                    return
                }
                completion(files.files)
            }
        }
    }
    
    func getFileSize(fileId: String, completion: @escaping (Int) -> Void) {
        GoogleDriveService.shared.getFileSize(fileId: fileId) { response in
            guard let fileSize = try? JSONDecoder().decode(GoogleDriveFileSize.self, from: response.data) else {
                DispatchQueue.main.async {
                    if ApplicationStore.shared.uistate.error == nil {
                        ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                    }
                }
                return
            }
            completion(Int(fileSize.size) ?? 0)
        }
    }
}
