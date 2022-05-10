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
    private var observation: NSKeyValueObservation?
    private init() {}
    
    func download(endpoint: Endpoint, ongoingDownloadId: Int?, completion: @escaping (DownloadResponse) -> Void) {
        let task = URLSession.shared.downloadTask(with: self.constructNewRequest(endpoint: endpoint, data: nil)) { url, response, error in
            let handledResponse = self.handleDownloadResponse(url: url, response: response, error: error, silentError: true)
            if !handledResponse.hasError {
                completion(handledResponse)
            }
            // repeat failed request one more time
            else {
                let repeatTask = URLSession.shared.downloadTask(with: self.constructNewRequest(endpoint: endpoint, data: nil)) { url, response, error in
                    let handledResponse = self.handleDownloadResponse(url: url, response: response, error: error, silentError: false)
                    if !handledResponse.hasError {
                        completion(handledResponse)
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    repeatTask.resume()
                }
            }
        }
        
        if let id = ongoingDownloadId {
            self.observation = task.progress.observe(\.fractionCompleted) { progress, _ in
                DispatchQueue.main.async {
                    ApplicationStore.shared.uistate.ongoingDownloads[id].percentageDone = Int(progress.fractionCompleted * 100)
                }
            }
        }
        task.resume()
    }
    
    func request(endpoint: Endpoint, data: Data?, completion: @escaping (NetworkResponse) -> Void) {
        if data != nil {
            let task = URLSession.shared.uploadTask(with: self.constructNewRequest(endpoint: endpoint, data: data), from: data!) { data, response, error in
                let handledResponse = self.handleResponse(endpoint: endpoint.url, data: data, response: response, error: error, silentError: true)
                if !handledResponse.hasError {
                    completion(handledResponse)
                }
                // repeat failed request one more time
                else {
                    let repeatTask = URLSession.shared.uploadTask(with: self.constructNewRequest(endpoint: endpoint, data: data), from: data!) { data, response, error in
                        let handledResponse = self.handleResponse(endpoint: endpoint.url, data: data, response: response, error: error, silentError: false)
                        if !handledResponse.hasError {
                            completion(handledResponse)
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        repeatTask.resume()
                    }
                }
            }

            task.resume()
        }
        
        else {
            let task = URLSession.shared.dataTask(with: self.constructNewRequest(endpoint: endpoint, data: nil)) { data, response, error in
                let handledResponse = self.handleResponse(endpoint: endpoint.url, data: data, response: response, error: error, silentError: true)
                if !handledResponse.hasError {
                    completion(handledResponse)
                }
                // repeat failed request one more time
                else {
                    let repeatTask = URLSession.shared.dataTask(with: self.constructNewRequest(endpoint: endpoint, data: nil)) { data, response, error in
                        let handledResponse = self.handleResponse(endpoint: endpoint.url, data: data, response: response, error: error, silentError: false)
                        if !handledResponse.hasError {
                            completion(handledResponse)
                        }
                    }
                    
                    repeatTask.resume()
                }
            }

            task.resume()
        }
    }
    
    private func handleResponse(endpoint: String, data: Data?, response: URLResponse?, error: Error?, silentError: Bool) -> NetworkResponse {
        let responseCode = (response as? HTTPURLResponse)?.statusCode ?? 404
        let hasError = !(200...399).contains(responseCode) || error != nil
        if hasError {
            print("ERROR", responseCode, ":\n", "\tEndpoint:", endpoint, "\nError body:\n")
            if data != nil {
                print(data != nil ? String(data: data!, encoding: .utf8)! : "no data")
            }
            if !silentError {
                DispatchQueue.main.async {
                    if ApplicationStore.shared.uistate.error == nil {
                        ApplicationStore.shared.uistate.error = ApplicationError(error: .network)
                    }
                }
            }
        }
        return NetworkResponse(
            hasError: hasError,
            data: data ?? Data(),
            code: responseCode,
            headers: (response as? HTTPURLResponse)?.headers.dictionary
        )
    }
    
    private func handleDownloadResponse(url: URL?, response: URLResponse?, error: Error?, silentError: Bool) -> DownloadResponse {
        let responseCode = (response as? HTTPURLResponse)?.statusCode ?? 404
        let hasError = !(200...399).contains(responseCode) || error != nil
        if hasError && !silentError {
            DispatchQueue.main.async {
                if ApplicationStore.shared.uistate.error == nil {
                    ApplicationStore.shared.uistate.error = ApplicationError(error: .network)
                }
            }
        }
        return DownloadResponse(hasError: hasError, tmpUrl: url)
    }
    
    private func constructNewRequest(endpoint: Endpoint, data: Data?) -> URLRequest {
        var request = URLRequest(url: URL(string: endpoint.url.replacingOccurrences(of: " ", with: "%20"))!)
        request.httpMethod = endpoint.httpMethod
        endpoint.headers.forEach({ header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        })
        
        if data != nil {
            request.httpBody = data
        }
        
        return request
    }
}
