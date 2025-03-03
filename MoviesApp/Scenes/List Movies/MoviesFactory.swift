//
//  MoviesFactory.swift
//  MoviesApp
//
//  Created by David López on 22/2/25.
//

import SwiftUI

final class MoviesFactory: MoviesFactoryType {
    
    private var cachedViewModel: MoviesViewModel?
    
    func makeModule(coordinator: AppCoordinator) -> some View {
        
        if let existingViewModel = cachedViewModel {
            return MoviesListView(viewModel: existingViewModel, coordinator: coordinator)
        }
        
        let interactor = MoviesInteractor()
        let favManager = FavoritesManager()
        let viewModel = MoviesViewModel(interactor: interactor, favoritesManager: favManager)
        cachedViewModel = viewModel
        
        return MoviesListView(viewModel: viewModel,coordinator: coordinator)
    }
    
    func clearCache() {
        cachedViewModel = nil
    }
}
