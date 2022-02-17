//
//  Endpoints.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 15/02/2022.
//

import Foundation

private let baseEP = "http://localhost:8080"
private let authEP = "/oauth"

let googleAuthEP = baseEP + authEP + "/google"
let microsoftAuthEP = baseEP + authEP + "/microsoft"
let dropboxAuthEP = baseEP + authEP + "/dropbox"

let uploadFileEP = baseEP + "/upload"
