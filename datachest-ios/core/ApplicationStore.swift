//
//  ApplicationStore.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 28/03/2022.
//

import Foundation
import SwiftUI

struct ApplicationError: Identifiable {
    let id = UUID().uuidString
    let error: String
}

struct ApplicationState {
    var googleDriveFolderIds: [DatachestFolders: String]
    var error: ApplicationError?
}

final class ApplicationStore: ObservableObject {
    static let shared = ApplicationStore()
    
    @Published var state = ApplicationState(
        googleDriveFolderIds: [:]
    )
    private init() {}
}
