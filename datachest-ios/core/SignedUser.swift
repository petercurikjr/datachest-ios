//
//  SignedUser.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 08/03/2022.
//

import Foundation

class SignedUser {
    var googleAccessToken: String = ""
    
    static let shared = SignedUser()
    private init() {}

}
