//
//  FirestoreModel.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 29/03/2022.
//

import Foundation

enum FirestoreCollections: String {
    case files
}

struct FirestoreFileDocument: Codable {
    let googleDriveShare: String
    let microsoftOneDriveShare: String
    let dropboxShare: String
}
