//
//  DetailMovieViewModel.swift
//  MoviesApp
//
//  Created by David López on 22/2/25.
//

import SwiftUI

final class MovieDetailViewModel: ObservableObject {
    
    @Published var movie: Movie
    @Published var isFavorite: Bool = false
    private let favoritesManager: FavoritesManagerProtocol
    
    private let maxPopularity: Double = 3000
    private let maxVoteCount: Double = 6000
    
    init(movie: Movie, favoritesManager: FavoritesManagerProtocol) {
        self.movie = movie
        self.favoritesManager = favoritesManager
        self.isFavorite = favoritesManager.isFavorite(movie.id)
    }
    
    struct MovieHeaderModel {
        
        let title: String
        let rating: String
        let releaseDate: String
        let language: String
        
        init(movie: Movie) {
            self.title = movie.title
            self.rating = movie.voteAverage.formattedRating
            self.releaseDate = movie.releaseDate
            self.language = movie.originalLanguage.uppercased()
        }
    }
    
    struct MovieVoteAverageModel {
        
        let voteAverage: Double
        let voteCategoryTitle: String
        let voteCategorySubtitle: String
        
        init(movie: Movie) {
            self.voteAverage = movie.voteAverage
            self.voteCategoryTitle = movie.voteAverageCategory.0
            self.voteCategorySubtitle = movie.voteAverageCategory.1
        }
    }
    
    func toggleFavorite() {
        isFavorite = favoritesManager.toggleFavorite(movie)
    }
}

extension MovieDetailViewModel {
    
    var overviewText: String {
        movie.overview
    }
    
    var backdropLargeURL: URL? {
        movie.backdropURL()
    }
    
    var backdropOriginalURL: URL? {
        movie.backdropURL(size: .original)
    }
    
    var popularityCategory: MovieCategoryProgress {
        
        let limit = movie.popularity / maxPopularity
        let value = limit > 1 ? 1 : limit
        return MovieCategoryProgress(name: "Popularidad", description: movie.popularityCategory, value: value, color: Color(#colorLiteral(red: 0.45, green: 0.73, blue: 0.6, alpha: 1)), icon: "person.2.fill")
    }
    
    var voteCountCategory: MovieCategoryProgress {
        
        let limit = movie.voteCount.toDouble / maxVoteCount
        let value = limit > 1 ? 1 : limit
        return MovieCategoryProgress(name: "Número de votos", description: movie.voteCountCategory, value: value, color: Color(#colorLiteral(red: 0.87, green: 0.68, blue: 0.45, alpha: 1)), icon: "leaf.fill")
    }
    
    var headerModel: MovieHeaderModel {
        MovieHeaderModel(movie: movie)
    }
    
    var voteAverageModel: MovieVoteAverageModel {
        MovieVoteAverageModel(movie: movie)
    }
    
    var favoriteButtonModel: FavoriteButtonModel {
        FavoriteButtonModel(
            isFavorite: isFavorite,
            title: isFavorite ? "Eliminar de favoritos" : "Añadir a favoritos",
            iconName: isFavorite ? "heart.fill" : "heart",
            backgroundColor: isFavorite ? Color.red : Color.blue
        )
    }
}
