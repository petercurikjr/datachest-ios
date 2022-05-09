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
        
        @Published var isUnlimitedStorageGoogle = false
        
        @Published var remainingSizeGoogle = "?"
        @Published var remainingSizeMicrosoft = "?"
        @Published var remainingSizeDropbox = "?"
        
        @Published var googleDriveStorageProgressBarValue: Float = 0
        @Published var microsoftOneDriveStorageProgressBarValue: Float = 0
        @Published var dropboxStorageProgressBarValue: Float = 0
                
        func getCloudQuotas() {
            GoogleDriveFacade.shared.getAboutData() { data in
                if data.quotaType == .unlimited {
                    DispatchQueue.main.async {
                        self.remainingSizeGoogle = "∞ storage"
                        self.isUnlimitedStorageGoogle = true
                    }
                    
                }
                else {
                    DispatchQueue.main.async {
                        self.isUnlimitedStorageGoogle = false
                        self.remainingSizeGoogle = self.formatRemainingBytes(remainingBytes: ((Int64(data.quotaBytesTotal) ?? 0) - (Int64(data.quotaBytesUsed) ?? 0)))
                        self.googleDriveStorageProgressBarValue = self.getDriveFillAmount(usedStorageSpace: Float(data.quotaBytesUsed), totalStorageSpace: Float(data.quotaBytesTotal))
                    }
                }
            }
            
            MicrosoftOneDriveFacade.shared.getDriveInfo() { data in
                DispatchQueue.main.async {
                    self.remainingSizeMicrosoft = self.formatRemainingBytes(remainingBytes: data.quota.remaining)
                    self.microsoftOneDriveStorageProgressBarValue = self.getDriveFillAmount(usedStorageSpace: (Float(data.quota.total) - Float(data.quota.remaining)), totalStorageSpace: Float(data.quota.total))
                }
            }
            
            DropboxFacade.shared.getSpaceUsage() { data in
                DispatchQueue.main.async {
                    self.remainingSizeDropbox = self.formatRemainingBytes(remainingBytes: (data.allocation.allocated - data.used))
                    self.dropboxStorageProgressBarValue = self.getDriveFillAmount(usedStorageSpace: Float(data.used), totalStorageSpace: Float(data.allocation.allocated))
                }
            }
        }
        
        func formatRemainingBytes(remainingBytes: Int64) -> String {
            return ByteCountFormatter.string(fromByteCount: remainingBytes, countStyle: .binary)
        }
        
        func getDriveFillAmount(usedStorageSpace: Float?, totalStorageSpace: Float?) -> Float {
            let amount = ((usedStorageSpace ?? 0) / (totalStorageSpace ?? 1)) * 100
            let oldRange = Float(100)
            let newRange = Float(170)
            let convertedAmountToFitRange = Float((amount * newRange) / oldRange)
            return convertedAmountToFitRange
        }
        
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
                if ApplicationStore.shared.uistate.error == nil {
                    ApplicationStore.shared.uistate.error = ApplicationError(error: .readIO)
                }
            }
        }
    }
}
