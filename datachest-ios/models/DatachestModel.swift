//
//  DatachestModel.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 21/03/2022.
//

import Foundation

struct ApplicationError: Identifiable {
    let id = UUID().uuidString
    let error: ErrorMessageType
}

enum ErrorMessageType: String {
    case db = "There was a problem with the app's database. Please try again later."
    case network = "Something went wrong when communicating with cloud providers. Please try again later."
    case dataParsing = "There was a problem parsing some data. Please try again later."
    case readIO = "An error ocurred while reading from this device's filesystem."
    case writeIO = "An error ocurred while writing to this device's filesystem."
    case notEnoughStorageSpace = "Cannot download this file. Insufficient space left on device."
    case decryption = "File decryption failed."
}

struct DatachestOngoingFileTransfer: Identifiable {
    let id: Int
    let owner: DatachestSupportedClouds
    let fileName: String
    var percentageDone: Int = 0
    var finished: Bool = false
}

struct DatachestKeyShareFile: Codable {
    let keyShare: String
    let mappedFileData: DatachestMappedFileData?
}

struct DatachestMappedFileData: Codable {
    let fileId: String
    let aesTag: [Data]
    let aesNonce: String
    let fileType: String
}

struct DatachestGoogleAuthKeychainItem: Codable {
    let accessTokenExpirationDate: Date
}

struct DatachestMicrosoftAuthKeychainItem: Codable {
    let accessTokenExpirationDate: Date
    let accountId: String
}

struct DatachestDropboxAuthKeychainItem: Codable {
    let accessTokenExpirationDate: Date
}

enum DatachestSupportedClouds: String {
    case google = "Google Drive"
    case microsoft = "Microsoft OneDrive"
    case dropbox = "Dropbox"
    
    static let allValues = [google, microsoft, dropbox]
}

enum DatachestFolders: String {
    case root = ""
    case datachest = "Datachest"
    case files = "Files"
    case keyshareAndMetadata = "Keys"
    
    var full: String {
        switch self {
        case .root:
            return "/"
        case .datachest:
            return "/Datachest"
        case .files:
            return "/Datachest/Files"
        case .keyshareAndMetadata:
            return "/Datachest/Keys"
        }
    }
}

enum DatachestFileBufferSizes {
    case googleDrive
    case microsoftOneDrive
    case dropbox
    
    var size: Int {
        switch self {
        case .googleDrive:
            return 4*262144
        case .microsoftOneDrive:
            return 3*327680
        case .dropbox:
            return 4*262144
        }
    }
}
