//
//  UploadViewModel.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 28/03/2022.
//

import Foundation

extension UploadView {
    class UploadViewModel: ObservableObject {
        @Published var showDocumentPickerGoogle = false
        @Published var showDocumentPickerDropbox = false
        @Published var showDocumentPickerMicrosoft = false
        
        func handleSelectedFile(cloudProvider: DatachestSupportedClouds, result: Result<URL, Error>) {
            do {
                let fileUrl = try result.get()
                switch cloudProvider {
                case .google:
                    GoogleDriveFacade.shared.uploadFile(fileUrl: fileUrl)
                case .microsoft:
                    MicrosoftOneDriveFacade.shared.uploadFile(fileUrl: fileUrl)
                case .dropbox:
                    DropboxFacade.shared.uploadFile(fileUrl: fileUrl)
                }
            }
            catch {
                ApplicationStore.shared.uistate.error = ApplicationError(error: .readIO)
            }
        }
    }
}
