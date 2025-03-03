//
//  Movie+Domain.swift
//  MoviesApp
//
//  Created by David López on 28/2/25.
//

import Foundation

extension Movie: Hashable {
    
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

extension Movie {
    
    var fullPosterPath: String {
        guard let posterPath = posterPath else { return "" }
        return APIConfiguration.ImageURLs.posterBase + posterPath
    }
    
    var fullBackdropPath: String {
        guard let backdropPath = backdropPath else { return "" }
        return APIConfiguration.ImageURLs.backdropBase + backdropPath
    }
    
    func posterURL(size: APIConfiguration.ImageURLs.PosterSize = .large) -> URL? {
        return APIConfiguration.ImageURLs.posterURL(path: posterPath, size: size)
    }
    
    func backdropURL(size: APIConfiguration.ImageURLs.BackdropSize = .large) -> URL? {
        return APIConfiguration.ImageURLs.backdropURL(path: backdropPath, size: size)
    }
}

extension Movie {
    
    var voteAverageCategory: (String, String) {
        
        switch self.voteAverage {
            
            case _ where voteAverage > 9: return ("Puntuación muy alta", "Es una película altamente recomendable para ver según las valoraciones.")
            case _ where voteAverage > 8: return ("Puntuación alta", "Es una película totalmente recomendable para ver según las valoraciones.")
            case _ where voteAverage > 7: return ("Puntuación  muy buena", "Es una película totalmente recomendable para ver según las valoraciones.")
            case _ where voteAverage > 6: return ("Puntuación buena", "Es una película totalmente recomendable para ver según las valoraciones.")
            case _ where voteAverage > 5: return ("Puntuación suficiente", "Es una película totalmente recomendable para ver según las valoraciones.")
            case _ where voteAverage > 2: return ("Puntuación baja", "Es una película totalmente recomendable para ver según las valoraciones.")
            default: return ("Puntuación muy baja", "Es una película totalmente recomendable para ver según las valoraciones.")
        }
    }
    
    var popularityCategory: String {
        
        switch self.popularity {
            
            case _ where popularity > 1000: return "Fenómeno global"
            case _ where popularity > 500: return "Extremadamente popular"
            case _ where popularity > 200: return "Muy popular"
            case _ where popularity > 100: return "Popular"
            case _ where popularity > 50: return "Moderadamente popular"
            case _ where popularity > 20: return "Algo conocida"
            default: return "Poco conocida"
        }
    }
    
    var voteCountCategory: String {
        
        switch self.voteCount {
            
            case _ where voteCount > 10000: return "Ampliamente evaluada"
            case _ where voteCount > 5000: return "Muy evaluada"
            case _ where voteCount > 1000: return "Bastante evaluada"
            case _ where voteCount > 500: return "Moderadamente evaluada"
            case _ where voteCount > 100: return "Algo evaluada"
            default: return "Pocas evaluaciones"
        }
    }
}
