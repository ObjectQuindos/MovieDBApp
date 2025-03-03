//
//  MockAPIClient.swift
//  MoviesApp
//
//  Created by David López on 26/2/25.
//

import Foundation
@testable import MoviesApp

class MockAPIClient: APIClientProtocol {
    
    var mockResponse: Data = Data()
    var mockError: Error? = nil
    var requestCallCount = 0
    var lastRequestedTask: APITask?
    
    let client = APIConfiguration.shared
    
    func request<T: APITask>(_ task: T) async throws -> Data {
        requestCallCount += 1
        lastRequestedTask = task
        
        if let error = mockError {
            throw error
        }
        
        return mockResponse
    }
    
    func request<T: APITask>(_ task: T) async throws -> JSON {
        return [:]
    }
}
