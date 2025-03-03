//
//  MovieDetailFactory.swift
//  MoviesApp
//
//  Created by David López on 22/2/25.
//

import SwiftUI

final class MovieDetailFactory: MovieDetailFactoryType {
    
    typealias DetailView = AnyView
    private var cachedViewModel: MovieDetailViewModel?
    
    func makeDetailModule(movie: Movie) -> DetailView {
        
        if let existingViewModel = cachedViewModel {
            return AnyView(MovieDetailScene(viewModel: existingViewModel))
        }
        
        let favManager = FavoritesManager()
        let viewModel = MovieDetailViewModel(movie: movie, favoritesManager: favManager)
        return AnyView(MovieDetailScene(viewModel: viewModel))
    }
    
    func clearCache() {
        cachedViewModel = nil
    }
}
