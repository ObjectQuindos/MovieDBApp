//
//  Untitled.swift
//  MoviesApp
//
//  Created by David López on 2/3/25.
//

import Foundation
import SwiftData

@Model
final class FavoriteMovie {
    
    var id: Int
    var title: String
    var originalTitle: String
    var overview: String
    var posterPath: String?
    var backdropPath: String?
    var releaseDate: String
    var voteAverage: Double
    var voteCount: Int
    var popularity: Double
    var dateAdded: Date
    
    init(movie: Movie) {
        self.id = movie.id
        self.title = movie.title
        self.originalTitle = movie.originalTitle
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.backdropPath = movie.backdropPath
        self.releaseDate = movie.releaseDate
        self.voteAverage = movie.voteAverage
        self.voteCount = movie.voteCount
        self.popularity = movie.popularity
        self.dateAdded = Date()
    }
    
    var toMovie: Movie {
        Movie(
            backdropPath: backdropPath,
            id: id,
            title: title,
            originalTitle: originalTitle,
            overview: overview,
            posterPath: posterPath,
            mediaType: "movie",
            adult: false,
            originalLanguage: "en",
            genreIds: [],
            popularity: popularity,
            releaseDate: releaseDate,
            video: false,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}

extension FavoriteMovie {
    
    static var defaultSort: [SortDescriptor<FavoriteMovie>] {
        [SortDescriptor(\.dateAdded, order: .reverse)]
    }
    
    static func withId(_ id: Int) -> Predicate<FavoriteMovie> {
        #Predicate { movie in
            movie.id == id
        }
    }
}
