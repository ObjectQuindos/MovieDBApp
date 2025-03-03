//
//  Untitled.swift
//  MoviesApp
//
//  Created by David López on 26/2/25.
//

import Foundation
@testable import MoviesApp

class MockMoviesInteractor: MoviesInteractor {
    
    var mockGetMoviesResult: Result<MovieResponse> = .success(MovieResponse(page: 1, totalPages: 0, totalResults: 0, results: []))
    var getMoviesCallCount = 0
    
    override func getMovies(page: Int) async throws -> MovieResponse {
        
        getMoviesCallCount += 1
        
        switch mockGetMoviesResult {
            
        case .success(let response):
            return response
            
        case .failure(let error):
            throw error
        }
    }
    
    func testFetchMoviesSuccess() async {
        
    }
}
