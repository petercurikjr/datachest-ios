//
//  ProfileViewModel.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 03/05/2022.
//

import Foundation

extension ProfileView {
    class ProfileViewModel: ObservableObject {
        @Published var googleName = ""
        @Published var microsoftName = ""
        @Published var dropboxName = ""
        
        func getProfileNameGoogleDrive() {
            GoogleDriveFacade.shared.getAboutData { data in
                DispatchQueue.main.async {
                    self.googleName = data.name
                }
            }
        }
        
        func getProfileNameMicrosoftOneDrive() {
            MicrosoftOneDriveFacade.shared.getDriveInfo { data in
                DispatchQueue.main.async {
                    self.microsoftName = data.owner.user.displayName
                }
            }
        }
        
        func getProfileNameDropbox() {
            DropboxFacade.shared.getCurrentAccount { data in
                DispatchQueue.main.async {
                    self.dropboxName = (data.name.given_name + " " + data.name.surname)
                }
            }
        }
    }
}
