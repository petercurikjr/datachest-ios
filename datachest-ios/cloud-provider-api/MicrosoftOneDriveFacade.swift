//
//  MicrosoftOneDriveFacade.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 14/03/2022.
//

import Foundation

class MicrosoftOneDriveFacade {
    static let shared = MicrosoftOneDriveFacade()
    
    private init() {}
    
    func getDriveInfo(completion: @escaping (MicrosoftOneDriveDriveInfoResponse) -> Void) {
        MicrosoftOneDriveService.shared.getDriveInfo() { response in
            guard let driveInfo = try? JSONDecoder().decode(MicrosoftOneDriveDriveInfoResponse.self, from: response.data) else {
                DispatchQueue.main.async {
                    if ApplicationStore.shared.uistate.error == nil {
                        ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                    }
                }
                return
            }
            completion(driveInfo)
        }
    }
    
    func uploadFile(fileUrl: URL) {
        let _ = MicrosoftOneDriveUploadSession(fileUrl: fileUrl)
    }
    
    func listFilesOnCloud(completion: @escaping ([MicrosoftOneDriveFileResponse]) -> Void) {
        let ccd = CommonCloudContainer()
        ccd.microsoftOneDriveCheckOrCreateAllFolders() {
            MicrosoftOneDriveService.shared.listFiles() { response in
                guard let files = try? JSONDecoder().decode(MicrosoftOneDriveFilesResponse.self, from: response.data) else {
                    DispatchQueue.main.async {
                        if ApplicationStore.shared.uistate.error == nil {
                            ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                        }
                    }
                    return
                }
                completion(files.value)
            }
        }
    }
}
