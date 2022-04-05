//
//  MicrosoftOneDriveFacade.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 14/03/2022.
//

import Foundation

class MicrosoftOneDriveFacade {
    static let shared = MicrosoftOneDriveFacade()
    var activeUploadSessions: [MicrosoftOneDriveUploadSession] = []
    
    private init() {}
    
    func uploadFile(fileUrl: URL) {
        activeUploadSessions.append(MicrosoftOneDriveUploadSession(fileUrl: fileUrl))
    }
    
    func listFilesOnCloud(completion: @escaping ([MicrosoftOneDriveFileResponse]) -> Void) {
        let ccd = CommonCloudContainer()
        ccd.microsoftOneDriveCheckOrCreateAllFolders() {
            MicrosoftOneDriveService.shared.listFiles() { response in
                guard let files = try? JSONDecoder().decode(MicrosoftOneDriveFilesResponse.self, from: response.data) else {
                    DispatchQueue.main.async {
                        ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                    }
                    return
                }
                completion(files.value)
            }
        }
    }
}
