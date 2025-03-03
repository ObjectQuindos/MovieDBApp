//
//  DIContainer.swift
//  MoviesApp
//
//  Created by David López on 23/2/25.
//

import SwiftUI

// MARK: - Movies Factory Protocol (Singleton solution) Not Used

final class AppFactory {
    
    // podrías usar inyección de dependencias
    static let shared = AppFactory()
    private init() {} // Prevent do not do more instances
    
    // Factories each module
    private(set) lazy var moviesFactory = MoviesFactory()
}

// MARK: - Movies Factory Protocol

protocol MoviesFactoryType {
    associatedtype MoviesView: View
    func makeModule(coordinator: AppCoordinator) -> MoviesView
    func clearCache()
}

// MARK: - Movie Detail Factory Protocol

protocol MovieDetailFactoryType {
    associatedtype DetailView: View
    func makeDetailModule(movie: Movie) -> DetailView
    func clearCache()
}

// MARK: - Favorites Factory Protocol

protocol FavoritesFactoryType {
    associatedtype FavoritesView: View
    func makeFavoritesModule(coordinator: AppCoordinator) -> FavoritesView
    func clearCache()
}

// MARK: - Dependency Container

protocol DependencyContainer {
    
    associatedtype Movies: MoviesFactoryType
    associatedtype Detail: MovieDetailFactoryType
    associatedtype Favorites: FavoritesFactoryType
    
    var moviesFactory: Movies { get }
    var movieDetailFactory: Detail { get }
    var favoritesFactory: Favorites { get }
}

final class AppDependencyContainer: DependencyContainer, ObservableObject {
    
    let moviesFactory: MoviesFactory
    let movieDetailFactory: MovieDetailFactory
    let favoritesFactory: FavoritesFactory
    
    init() {
        self.moviesFactory = MoviesFactory()
        self.movieDetailFactory = MovieDetailFactory()
        self.favoritesFactory = FavoritesFactory()
    }
}
