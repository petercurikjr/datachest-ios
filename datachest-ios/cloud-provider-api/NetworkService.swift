//
//  NetworkService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation

class NetworkService {
    func request(endpoint: Endpoint, data: Data?, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: endpoint.url)!)
        request.httpMethod = endpoint.httpMethod
        endpoint.headers.forEach({ header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        })
        request.httpBody = data
        
        if data != nil {
            let task = URLSession.shared.uploadTask(with: request, from: data!) { data, response, error in
                completion(data, response as? HTTPURLResponse, error)
            }

            task.resume()
        }
        
        else {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                completion(data, response as? HTTPURLResponse, error)
            }

            task.resume()
        }
    }
}
