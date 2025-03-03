//
//  Untitled.swift
//  MoviesApp
//
//  Created by David López on 26/2/25.
//

import XCTest
@testable import MoviesApp

class MockMoviesService: MoviesService {
    
    var mockGetMoviesResult: Result<MovieResponse> = .success(MovieResponse(page: 1, totalPages: 0, totalResults: 0, results: []))
    var getMoviesCallCount = 0
    
    init() {
        super.init(client: APIClient(configuration: APIConfiguration.shared))
    }
    
    override func getMovies(page: Int) async throws -> MovieResponse {
        getMoviesCallCount += 1
        
        switch mockGetMoviesResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
