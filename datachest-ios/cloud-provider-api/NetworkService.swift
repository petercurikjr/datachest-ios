//
//  NetworkService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation

struct NetworkError: Identifiable {
    let id = UUID().uuidString
    let error: String
}

struct NetworkResponse {
    let hasError: Bool
    let data: Data
    let code: Int
    let headers: [String : String]?
}

class NetworkService: ObservableObject {
    static let shared = NetworkService()
    private init() {}
    
    @Published var networkError: NetworkError? = nil
    
    func request(endpoint: Endpoint, data: Data?, completion: @escaping (NetworkResponse) -> Void) {
        var request = URLRequest(url: URL(string: endpoint.url)!)
        request.httpMethod = endpoint.httpMethod
        endpoint.headers.forEach({ header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        })
        request.httpBody = data
        
        if data != nil {
            let task = URLSession.shared.uploadTask(with: request, from: data!) { data, response, error in
                let handledResponse = self.handleResponse(data: data, response: response, error: error)
                if !handledResponse.hasError {
                    completion(self.handleResponse(data: data, response: response, error: error))
                }
            }

            task.resume()
        }
        
        else {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                let handledResponse = self.handleResponse(data: data, response: response, error: error)
                if !handledResponse.hasError {
                    completion(self.handleResponse(data: data, response: response, error: error))
                }
            }

            task.resume()
        }
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?) -> NetworkResponse {
        let responseCode = (response as? HTTPURLResponse)?.statusCode ?? 404
        let hasError = !((200...299).contains(responseCode) || (responseCode == 308)) || error != nil
        if hasError {
            DispatchQueue.main.async {
                self.networkError = NetworkError(error: "Something went wrong when communicating with cloud providers. Please try again later.")
            }
        }
        return NetworkResponse(
            hasError: hasError,
            data: data ?? Data(),
            code: responseCode,
            headers: (response as? HTTPURLResponse)?.headers.dictionary
        )
    }
}
