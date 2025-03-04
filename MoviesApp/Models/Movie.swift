//
//  Movie.swift
//  MoviesApp
//
//  Created by David López on 20/2/25.
//

import Foundation

struct Movie: Codable, Identifiable {
    
    let backdropPath: String?
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let mediaType: String
    let adult: Bool
    let originalLanguage: String
    let genreIds: [Int]
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case originalLanguage = "original_language"
        case genreIds = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
