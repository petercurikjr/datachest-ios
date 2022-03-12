//
//  Endpoint.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 08/03/2022.
//

protocol Endpoint {
    var url: String { get }
    var httpMethod: String { get }
    var headers: [String: String] { get }
}
