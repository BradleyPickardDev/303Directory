//
//  JSONParser.swift
//  Codename 303
//
//  Created by Bradley Pickard on 8/6/19.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import Foundation

class JSONParser {
    static let shared = JSONParser()
    public var rawData: String = ""
    
    public struct Contact: Codable {
        let fname: String
        let lname: String
        let city: String
    }
    
    public func decodeData() -> Array<JSONParser.Contact>{
        log.ln(rawData)/
        let jsonData = rawData.data(using: .utf8)!
        let decoder = JSONDecoder()
        let decodedContacts = try! decoder.decode([Contact].self, from: jsonData)
        log.any(decodedContacts)/
        return decodedContacts
    }
}
