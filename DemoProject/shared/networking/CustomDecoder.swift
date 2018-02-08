//
//  CustomDecoder.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import Foundation

class CustomDecoder {
    
    // Tries to decode data to a given type
    
    static func decode<T>(type: T.Type, data: Data) throws -> T where T: Decodable {
        let decoder = JSONDecoder()
        
        do {
            let result = try decoder.decode(type, from: data)
            return result
        } catch {
            debugPrint(error)
            throw error
        }
    }
    
}
