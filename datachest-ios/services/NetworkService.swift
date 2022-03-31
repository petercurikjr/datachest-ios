//
//  NetworkService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation

struct NetworkResponse {
    let hasError: Bool
    let data: Data
    let code: Int
    let headers: [String : String]?
}

struct DownloadResponse {
    let hasError: Bool
    let tmpUrl: URL?
}

class NetworkService: ObservableObject {
    static let shared = NetworkService()
    private init() {}
    
    func download(endpoint: Endpoint, completion: @escaping (DownloadResponse) -> Void) {
        var request = URLRequest(url: URL(string: endpoint.url)!)
        endpoint.headers.forEach({ header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        })
        let task = URLSession.shared.downloadTask(with: request) { url, response, error in
            let handledResponse = self.handleDownloadResponse(url: url, response: response, error: error)
            if !handledResponse.hasError {
                completion(handledResponse)
            }
        }
        
        task.resume()
    }
    
    func request(endpoint: Endpoint, data: Data?, completion: @escaping (NetworkResponse) -> Void) {
        var request = URLRequest(url: URL(string: endpoint.url)!)
        request.httpMethod = endpoint.httpMethod
        endpoint.headers.forEach({ header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        })
        request.httpBody = data
        
        if data != nil {
            let task = URLSession.shared.uploadTask(with: request, from: data!) { data, response, error in
                let handledResponse = self.handleResponse(endpoint: endpoint, data: data, response: response, error: error)
                if !handledResponse.hasError {
                    completion(handledResponse)
                }
            }

            task.resume()
        }
        
        else {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                let handledResponse = self.handleResponse(endpoint: endpoint, data: data, response: response, error: error)
                if !handledResponse.hasError {
                    completion(handledResponse)
                }
            }

            task.resume()
        }
    }
    
    private func handleResponse(endpoint: Endpoint, data: Data?, response: URLResponse?, error: Error?) -> NetworkResponse {
        let responseCode = (response as? HTTPURLResponse)?.statusCode ?? 404
        let hasError = !(200...399).contains(responseCode) || error != nil
        if hasError {
            print("ERROR", responseCode, ":\n", "\tEndpoint:", endpoint.url, "\nError body:\n")
            if data != nil {
                print(data != nil ? String(data: data!, encoding: .utf8)! : "no data")
            }
            DispatchQueue.main.async {
                ApplicationStore.shared.uistate.error = ApplicationError(error: .network)
            }
        }
        return NetworkResponse(
            hasError: hasError,
            data: data ?? Data(),
            code: responseCode,
            headers: (response as? HTTPURLResponse)?.headers.dictionary
        )
    }
    
    private func handleDownloadResponse(url: URL?, response: URLResponse?, error: Error?) -> DownloadResponse {
        let responseCode = (response as? HTTPURLResponse)?.statusCode ?? 404
        let hasError = !(200...399).contains(responseCode) || error != nil
        if hasError {
            DispatchQueue.main.async {
                ApplicationStore.shared.uistate.error = ApplicationError(error: .network)
            }
        }
        return DownloadResponse(hasError: hasError, tmpUrl: url)
    }
}
