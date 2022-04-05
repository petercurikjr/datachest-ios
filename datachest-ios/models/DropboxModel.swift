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
    let commit: DropboxCreateItemCommit
}

struct DropboxUploadFileCursor: Codable {
    let session_id: String
    let offset: Int
}

struct DropboxCreateItemCommit: Codable {
    let path: String
    let mode: String?
    let autorename: Bool?
}

struct DropboxDownloadFileMetadata: Codable {
    let path: String
}

struct DropboxFileResponse: Codable, Identifiable {
    let name: String
    let id: String
    let size: Int?
}

struct DropboxListFilesRequest: Codable {
    let path: String
    let include_deleted: Bool
}

struct DropboxListFilesResponse: Codable {
    let entries: [DropboxFileResponse]
    let cursor: String
    let has_more: Bool
}
