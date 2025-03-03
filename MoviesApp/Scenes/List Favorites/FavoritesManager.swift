//
//  FavoritesManager.swift
//  MoviesApp
//
//  Created by David López on 2/3/25.
//

import Foundation
import SwiftData
import SwiftUI

protocol FavoritesManagerProtocol {
    func addFavorite(_ movie: Movie)
    func removeFavorite(_ movieId: Int)
    func isFavorite(_ movieId: Int) -> Bool
    func getAllFavorites() -> [Movie]
    func toggleFavorite(_ movie: Movie) -> Bool
}

@Observable
final class FavoritesManager: FavoritesManagerProtocol {
    
    private var modelContext: ModelContext
    
    init(modelContainer: ModelContainer) {
        self.modelContext = ModelContext(modelContainer)
    }
    
    convenience init() {
        
        do {
            let container = try ModelContainer(for: FavoriteMovie.self)
            self.init(modelContainer: container)
            
        } catch {
            fatalError("Failed to create ModelContainer for FavoriteMovie: \(error.localizedDescription)")
        }
    }
    
    func addFavorite(_ movie: Movie) {
        guard !isFavorite(movie.id) else { return }
        
        let favoriteMovie = FavoriteMovie(movie: movie)
        modelContext.insert(favoriteMovie)
        saveContext()
    }
    
    func removeFavorite(_ movieId: Int) {
        
        do {
            let descriptor = FetchDescriptor<FavoriteMovie>(predicate: FavoriteMovie.withId(movieId))
            let results = try modelContext.fetch(descriptor)
            
            results.forEach { favoriteMovie in
                modelContext.delete(favoriteMovie)
            }
            
            saveContext()
            
        } catch {
            print("Error removing favorite: \(error.localizedDescription)")
        }
    }
    
    func isFavorite(_ movieId: Int) -> Bool {
        
        do {
            let descriptor = FetchDescriptor<FavoriteMovie>(predicate: FavoriteMovie.withId(movieId))
            let count = try modelContext.fetchCount(descriptor)
            return count > 0
            
        } catch {
            print("Error checking if movie is favorite: \(error.localizedDescription)")
            return false
        }
    }
    
    func getAllFavorites() -> [Movie] {
        
        do {
            let descriptor = FetchDescriptor<FavoriteMovie>(sortBy: FavoriteMovie.defaultSort)
            let favoriteMovies = try modelContext.fetch(descriptor)
            return favoriteMovies.map { $0.toMovie }
            
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
            return []
        }
    }
    
    func toggleFavorite(_ movie: Movie) -> Bool {
        
        if isFavorite(movie.id) {
            removeFavorite(movie.id)
            return false
            
        } else {
            addFavorite(movie)
            return true
        }
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
            
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
