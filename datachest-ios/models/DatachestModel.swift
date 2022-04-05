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

enum DatachestSupportedClouds: String {
    case microsoft = "Microsoft OneDrive"
    case google = "Google Drive"
    case dropbox = "Dropbox"
    
    static let allValues = [microsoft, google, dropbox]
}

enum DatachestFolders: String {
    case root = "Datachest"
    case files = "Files"
    case keyshareAndMetadata = "Keys"
    
    var full: String {
        switch self {
        case .root:
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
