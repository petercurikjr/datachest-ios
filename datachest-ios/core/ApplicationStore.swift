//
//  ApplicationStore.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 28/03/2022.
//

import Foundation
import SwiftUI

struct ApplicationState {
    var googleDriveFolderIds: [DatachestFolders: String]
    var googleAccessToken: String
    var microsoftAccessToken: String
    var dropboxAccessToken: String
}

struct UIState {
    var error: ApplicationError?
    var signedInGoogle: Bool
    var signedInMicrosoft: Bool
    var signedInDropbox: Bool
}

final class ApplicationStore: ObservableObject {
    static let shared = ApplicationStore()
    
    var state = ApplicationState(
        googleDriveFolderIds: [:],
        googleAccessToken: "",
        microsoftAccessToken: "",
        dropboxAccessToken: ""
    )
    @Published var uistate = UIState(
        error: nil,
        signedInGoogle: false,
        signedInMicrosoft: false,
        signedInDropbox: false
    )
    var signedInAll: Bool? {
        if [self.state.googleAccessToken, self.state.microsoftAccessToken, self.state.dropboxAccessToken].contains("")
            && !UserDefaults.standard.bool(forKey: "signed-out-google")
            && !UserDefaults.standard.bool(forKey: "signed-out-microsoft")
            && !UserDefaults.standard.bool(forKey: "signed-out-dropbox")
        {
            return nil
        }
        return self.uistate.signedInGoogle && self.uistate.signedInMicrosoft && self.uistate.signedInDropbox
    }
    
    private init() {}
    
    public func setGoogleAccessToken(token: String) {
        DispatchQueue.main.async {
            self.uistate.signedInGoogle = true
        }
        self.state.googleAccessToken = token
    }
    
    public func setMicrosoftAccessToken(token: String) {
        DispatchQueue.main.async {
            self.uistate.signedInMicrosoft = true
        }
        self.state.microsoftAccessToken = token
    }
    
    public func setDropboxAccessToken(token: String) {
        DispatchQueue.main.async {
            self.uistate.signedInDropbox = true
        }
        self.state.dropboxAccessToken = token
    }
}
