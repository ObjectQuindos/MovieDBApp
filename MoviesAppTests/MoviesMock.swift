//
//  MoviesMock.swift
//  MoviesApp
//
//  Created by David López on 26/2/25.
//

import Foundation
@testable import MoviesApp

extension Movie {
    
    static let getMockMovies: [Movie] = [movie1, movie2]
    
    private static let movie1 = Movie(
        backdropPath: "/sample_backdrop1.jpg",
        id: 12345,
        title: "Test Movie 1",
        originalTitle: "Original Test Movie 1",
        overview: "This is a test movie overview",
        posterPath: "/sample_poster1.jpg",
        mediaType: "movie",
        adult: false,
        originalLanguage: "en",
        genreIds: [28, 12],
        popularity: 123.45,
        releaseDate: "2025-01-15",
        video: false,
        voteAverage: 7.8,
        voteCount: 1234
    )
    
    private static let movie2 = Movie(
        backdropPath: "/sample_backdrop2.jpg",
        id: 67890,
        title: "Test Movie 2",
        originalTitle: "Original Test Movie 2",
        overview: "This is another test movie overview",
        posterPath: "/sample_poster2.jpg",
        mediaType: "movie",
        adult: true,
        originalLanguage: "es",
        genreIds: [35, 10749],
        popularity: 99.99,
        releaseDate: "2024-12-31",
        video: true,
        voteAverage: 6.5,
        voteCount: 999
    )
}
