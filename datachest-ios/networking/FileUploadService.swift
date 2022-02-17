//
//  FileUploadService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 15/02/2022.
//

import Foundation

func uploadFile(uploadData: Data) {
    var request = URLRequest(url: URL(string: uploadFileEP)!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = uploadData
    
    // todo vyskusat ci to pojde aj ked nesetnem httpBody
    let task = URLSession.shared.uploadTask(with: request, from: uploadData, completionHandler: {
        (data, response, error) in
        
        if let error = error {
            print("error: \(error)")
            return
        }
        
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode) else {
            print("server error")
            return
        }
        
        ///Success
        if data != nil {
            print(String(data: data!, encoding: .utf8)!)
        }
    })
    task.resume()
}
