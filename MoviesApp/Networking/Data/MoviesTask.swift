//
//  MoviesTask.swift
//  MoviesApp
//
//  Created by David López on 23/2/25.
//

import Foundation

enum MoviesTask: APITask {
    
    case getMovies(page: Int)
}

extension MoviesTask {
    
    var path: String {
        
        switch self {
        case .getMovies: return "trending/movie/week"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        
        switch self {
        case .getMovies(let page):
            return [ URLQueryItem(name: "page", value: String(page)) ]
        }
    }
    
    var parameters: Parameters {
        return [:]
    }
}
