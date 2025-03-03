//
//  MovieService.swift
//  MoviesApp
//
//  Created by David López on 22/2/25.
//

import Foundation

class MoviesService: Service {
    
    private let client: APIClientProtocol
    
    init(client: APIClientProtocol) {
        self.client = client
    }
    
    func getMovies(page: Int) async throws -> MovieResponse {
        
        let task = MoviesTask.getMovies(page: page)
        
        do {
            dataResponse = try await client.request(task)
            
        } catch { throw NetworkError.notFound }
        
        do {
            return try decode(MovieResponse.self, response: dataResponse)
            
        } catch { throw NetworkError.decodeError }
    }
}
