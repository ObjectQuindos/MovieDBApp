//
//  Service.swift
//  MoviesApp
//
//  Created by David López on 22/2/25.
//

import Foundation

class Service {
    
    var dataResponse = Data()
    
    func decode<T>(_ data: T.Type, responseData: Data) throws -> T where T: Codable {
        
        let decoder = JSONDecoder()
        
        do {
            let responseDecoded = try decoder.decode(T.self, from: responseData)
            return responseDecoded
            
        } catch let error {
            throw error
        }
    }
    
    func decode<T>(_ data: T.Type, response: Data) throws -> T where T: Decodable {
        
        let decoder = JSONDecoder()
        
        do {
            let responseDecoded = try decoder.decode(T.self, from: response)
            return responseDecoded
            
        } catch let error {
            throw error
        }
    }
}
