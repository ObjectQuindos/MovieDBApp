//
//  FavoritesListScene.swift
//  MoviesApp
//
//  Created by David López on 2/3/25.
//

import SwiftUI

struct FavoritesListView: View {
    
    @StateObject private var viewModel: FavoritesViewModel
    @ObservedObject private var coordinator: AppCoordinator
    
    init(viewModel: FavoritesViewModel, coordinator: AppCoordinator) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    var body: some View {
        
        VStack {
            
            moviesList
                .contentState(viewModel.contentState)
        }
        .navigationTitle("Mis Favoritos")
        .onAppear {
            viewModel.loadFavorites()
        }
    }
    
    private var moviesList: some View {
        
        List {
            
            ForEach(viewModel.favoriteMovies) { movie in
                
                Button {
                    coordinator.showMovieDetail(movieId: movie)
                    
                } label: {
                    
                    MovieRowView(
                        model: MovieRowModel(movie: movie),
                        isFavorite: true,
                        onFavoriteToggle: {
                            viewModel.toggleFavorite(movie)
                        }
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .swipeActions {
                    Button(role: .destructive) {
                        
                        withAnimation {
                            viewModel.toggleFavorite(movie)
                        }
                        
                    } label: {
                        Label("Quitar de favoritos", systemImage: "heart.slash")
                    }
                }
            }
        }
    }
}

#Preview {
    FavoritesFactory().makeFavoritesModule(coordinator: AppCoordinator())
}
