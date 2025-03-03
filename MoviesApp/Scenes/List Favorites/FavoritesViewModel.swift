//
//  Favorites.swift
//  MoviesApp
//
//  Created by David López on 2/3/25.
//

import Foundation
import SwiftUI

final class FavoritesViewModel: BaseViewModel {
    
    @Published private(set) var favoriteMovies: [Movie] = []
    private let favoritesManager: FavoritesManagerProtocol
    
    // Cache IDs
    private var favoriteIds = Set<Int>()
    
    init(favoritesManager: FavoritesManagerProtocol) {
        self.favoritesManager = favoritesManager
        
        super.init()
        loadFavorites()
    }
    
    func loadFavorites() {
        isLoading = true
        
        self.favoriteMovies = self.favoritesManager.getAllFavorites()
        self.isEmptySourceData = self.favoriteMovies.isEmpty
        self.updateFavoriteIdsCache()
        
        self.isLoading = false
    }
    
    func toggleFavorite(_ movie: Movie) {
        let isFavorite = favoritesManager.toggleFavorite(movie)
        
        if !isFavorite { // Remove movie
            favoriteMovies.removeAll { $0.id == movie.id }
            favoriteIds.remove(movie.id) // Update cache
            isEmptySourceData = favoriteMovies.isEmpty
            
        } else { // Add movie
            
            if !favoriteIds.contains(movie.id) {
                favoriteMovies.append(movie)
                favoriteIds.insert(movie.id) // Update cache
            }
        }
    }
    
    func isFavorite(_ movieId: Int) -> Bool {
        return favoriteIds.contains(movieId)
    }
    
    // Update cache when load
    private func updateFavoriteIdsCache() {
        favoriteIds = Set(favoriteMovies.map { $0.id })
    }
}

extension FavoritesViewModel: ContentStateViewModel {
    
    var contentState: ContentState {
        determineContentState(
            isLoading: isLoading,
            error: error,
            isEmpty: isEmptySourceData,
            retryAction: { self.loadFavorites() },
            retryAsyncAction: nil,
            emptyMessage: "No tienes películas favoritas guardadas"
        )
    }
}
