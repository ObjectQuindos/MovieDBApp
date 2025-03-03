//
//  Configuration.swift
//  MoviesApp
//
//  Created by David López on 3/3/25.
//

import Foundation

struct AppConfiguration {
    
    let baseURL: String
    let apiKey: String
    
    static var current: AppConfiguration {
        
        return AppConfiguration(
            baseURL: "https://api.themoviedb.org/3",
            apiKey: AppConfiguration.getAPIKey()
        )
    }
    
    private static func getAPIKey() -> String {
        
        if let apiKey = Bundle.main.infoDictionary?["TMDBApiKey"] as? String {
            return "Bearer \(apiKey)"
        }
        
        return ""
        // Sensible data -> Keychain
    }
}

class APIConfiguration {
    
    static let shared = APIConfiguration()
    
    static var baseURL: String {
        return AppConfiguration.current.baseURL
    }
    
    static var auth: String {
        return AppConfiguration.current.apiKey
    }
    
    struct ImageURLs {
        
        static let posterBase = "https://image.tmdb.org/t/p/w500"
        static let backdropBase = "https://image.tmdb.org/t/p/w1280"
        
        enum PosterSize: String {
            
            case small = "w92"
            case medium = "w185"
            case large = "w500"
            case original = "original"
            
            var path: String {
                return "https://image.tmdb.org/t/p/\(self.rawValue)"
            }
        }
        
        enum BackdropSize: String {
            
            case small = "w300"
            case medium = "w780"
            case large = "w1280"
            case original = "original"
            
            var path: String {
                return "https://image.tmdb.org/t/p/\(self.rawValue)"
            }
        }
        
        static func posterURL(path: String?, size: PosterSize = .large) -> URL? {
            guard let path = path, !path.isEmpty else { return nil }
            return URL(string: size.path + path)
        }
        
        static func backdropURL(path: String?, size: BackdropSize = .large) -> URL? {
            guard let path = path, !path.isEmpty else { return nil }
            return URL(string: size.path + path)
        }
    }
    
    func makeClient() -> NetworkEdge? {
        guard let url = URL(string: APIConfiguration.baseURL) else { return nil }
        return NetworkEdge(url: url)
    }
}
