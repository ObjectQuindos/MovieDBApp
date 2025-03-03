//
//  APIClient.swift
//  MoviesApp
//
//  Created by David López on 21/2/25.
//

import Foundation

protocol APIClientProtocol {
    func request<T: APITask>(_ task: T) async throws -> Data
    func request<T: APITask>(_ task: T) async throws -> JSON
}

final class APIClient: APIClientProtocol {
    
    private let configuration: APIConfiguration
    private let client : NetworkEdge // Our session (URLSession)
    
    init(configuration: APIConfiguration) {
        self.configuration = configuration
        self.client = configuration.makeClient()!
    }
    
    @discardableResult
    func request<T: APITask>(_ task: T) async throws -> Data {
        
        return try await withCheckedThrowingContinuation ( { (continuation: CheckedContinuation<Data, Error>) in
            
            client.makeRequest(task) { result in
                
                switch result {
                    
                case .success(let data):
                    
                    if let data = data as? Data {
                        continuation.resume(returning: data)
                        
                    } else {
                        continuation.resume(throwing: NetworkError.dataNotFound)
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
    
    @discardableResult
    func request<T: APITask>(_ task: T) async throws -> JSON {
        
        return try await withCheckedThrowingContinuation ( { (continuation: CheckedContinuation<JSON, Error>) in
            
            client.makeRequest(task) { result in
                
                switch result {
                    
                case .success(_):
                    continuation.resume(returning: [:])
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
}
