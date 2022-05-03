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

        func getProfileNames() {
            GoogleDriveFacade.shared.getAboutData { data in
                DispatchQueue.main.async {
                    self.googleName = data.name
                }
            }
            
            MicrosoftOneDriveFacade.shared.getDriveInfo { data in
                DispatchQueue.main.async {
                    self.microsoftName = data.owner.user.displayName
                }
            }
            
            DropboxFacade.shared.getCurrentAccount { data in
                DispatchQueue.main.async {
                    self.dropboxName = (data.name.given_name + " " + data.name.surname)
                }
            }
        }
    }
}
