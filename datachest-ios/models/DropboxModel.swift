//
//  DropboxModel.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation

struct DropboxUploadFileMetadata: Codable {
    let cursor: DropboxUploadFileCursor
    let close: Bool
}

struct DropboxFinishUploadMetadata: Codable {
    let cursor: DropboxUploadFileCursor
    let commit: DropboxUploadFileCommit
}

struct DropboxUploadFileCursor: Codable {
    let session_id: String
    let offset: Int
}

struct DropboxUploadFileCommit: Codable {
    let path: String
    let mode: String
    let autorename: Bool
}
