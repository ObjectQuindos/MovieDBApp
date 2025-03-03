//
//  MovieResponse.swift
//  MoviesApp
//
//  Created by David López on 20/2/25.
//

import Foundation

struct MovieResponse: Codable {
    
    let page, totalPages, totalResults: Int
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
