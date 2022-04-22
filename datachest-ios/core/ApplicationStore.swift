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
        error: nil
    )
    
    private init() {}
}
