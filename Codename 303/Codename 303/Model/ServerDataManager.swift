//
//  ServerDataManager.swift
//  Cloud9 Online
//
//  Created by Bradley Pickard on 9/18/18.
//  Copyright © 2018 Bradley Pickard. All rights reserved.
//

import Foundation

class ServerDataManager {
    static let shared = ServerDataManager()
    let jsonURL = "http://www.filltext.com/?rows=100&fname=%7BfirstName%7D&lname=%7BlastName%7D&city=%7Bcity%7D&pretty=true"
    public var decodedContacts: Array<JSONParser.Contact>?

    
    
    public func loadFileFromWeb() {
        let fullURLPath = jsonURL
        let request = NSMutableURLRequest(url: URL(string: fullURLPath)!)
        httpGet(request as URLRequest?) {
            (data, error) -> Void in
            if error != nil {
                log.ln(error!)/
            } else {
                DispatchQueue.main.async {
                    self.storeRawDataFromServer(data: data)
                }
            }
        }
    }//end of request
    
    private func httpGet(_ request: URLRequest!, callback: @escaping (String, String?) -> Void) {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession.init(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                callback("", error!.localizedDescription)
            } else {
                let result = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)!
                if result.contains("Error") {
                    log.ln("Unable to retrieve data: \(result)")/
                    callback("", "Unable to retrieve new data")
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .downloadError, object: nil)
//                        NotificationCenter.default.post(name: .downloadProgress, object: 1)
                    }
                    return
                }
                callback(result as String, nil)
            }
        })
        task.resume()
    }
    
    private func storeRawDataFromServer(data: String) {
        let rawDataStringFromServer = data
        let jsonParser = JSONParser.shared
        jsonParser.rawData = rawDataStringFromServer
        decodedContacts = jsonParser.decodeData()
        NotificationCenter.default.post(name: .loadFileFromWebComplete, object: nil)
    }
    
}

extension Notification.Name {
    static let downloadError = NSNotification.Name("downloadError")
    static let loadFileFromWebComplete = NSNotification.Name("loadFileFromWebComplete")
}
