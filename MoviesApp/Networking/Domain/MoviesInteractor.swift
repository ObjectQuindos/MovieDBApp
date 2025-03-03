//
//  MoviesInteractor.swift
//  MoviesApp
//
//  Created by David López on 22/2/25.
//

import Foundation

protocol MoviesUseCase {
    func getMovies(page: Int) async throws -> MovieResponse
    func getDetailMovie() async throws
}

class MoviesInteractor: MoviesUseCase {
    
    private let service: MoviesService
    
    init(service: MoviesService? = nil) {
        let initService = service ?? MoviesService(client: APIClient(configuration: APIConfiguration.shared))
        self.service = initService
    }
    
    func getMovies(page: Int) async throws -> MovieResponse {
        try await service.getMovies(page: page)
    }
    
    func getDetailMovie() async throws {
        
    }
}
