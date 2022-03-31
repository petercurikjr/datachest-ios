//
//  DeviceHelper.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 29/03/2022.
//

import Foundation

class DeviceHelper {
    static let shared = DeviceHelper()
    private init() {}

    func getAvailableStorageSpace() -> Int64? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: paths.last!) {
            if let freeBytes = dictionary[FileAttributeKey.systemFreeSize] as? NSNumber {
                return freeBytes.int64Value
            }
        }
        
        ApplicationStore.shared.uistate.error = ApplicationError(error: .readIO)
        return nil
    }
    
    func createOrGetFolder(folder: DatachestFolders) -> URL? {
        let documentsFolder = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let folderURL = documentsFolder.appendingPathComponent(folder.rawValue)
        let folderExists = (try? folderURL.checkResourceIsReachable()) ?? false
        
        do {
            if !folderExists {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: false)
            }
        }
        catch {
            ApplicationStore.shared.uistate.error = ApplicationError(error: .writeIO)
        }

        return folderURL
    }
    
    func createFile(atLocation: URL, fileName: String) -> URL? {
        let folderExists = (try? atLocation.checkResourceIsReachable()) ?? false
        if folderExists {
            let filePath = atLocation.appendingPathComponent(fileName)
            let success = FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
            if !success {
                ApplicationStore.shared.uistate.error = ApplicationError(error: .writeIO)
            }
            return filePath
        }
        return nil
    }
}
