//
//  FavoritesFactory.swift
//  MoviesApp
//
//  Created by David López on 2/3/25.
//

import SwiftUI

final class FavoritesFactory: FavoritesFactoryType {
    
    private var cachedViewModel: FavoritesViewModel?
    
    func makeFavoritesModule(coordinator: AppCoordinator) -> some View {
        
        if let existingViewModel = cachedViewModel {
            return FavoritesListView(viewModel: existingViewModel, coordinator: coordinator)
        }
        
        let favManager = FavoritesManager()
        let viewModel = FavoritesViewModel(favoritesManager: favManager)
        cachedViewModel = viewModel
        
        return FavoritesListView(viewModel: viewModel, coordinator: coordinator)
    }
    
    func clearCache() {
        cachedViewModel = nil
    }
}
