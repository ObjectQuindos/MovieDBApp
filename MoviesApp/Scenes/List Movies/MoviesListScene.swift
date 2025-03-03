//
//  MoviesListView.swift
//  MoviesApp
//
//  Created by David López on 20/2/25.
//

import SwiftUI

// MARK: - View

struct MoviesListView: View {
    
    @StateObject private var viewModel: MoviesViewModel
    @ObservedObject private var coordinator: AppCoordinator
    
    init(viewModel: MoviesViewModel, coordinator: AppCoordinator) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    var body: some View {
        
        VStack {
            
            moviesList
                .contentState(viewModel.contentState)
        }
        .navigationTitle("Movies")
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Text("Page \(viewModel.currentPage) of \(viewModel.totalPages)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .task {
            if viewModel.movies.isEmpty {
                await viewModel.fetchMovies()
            }
        }
        .onAppear {
            viewModel.updateFavoriteStatus()
        }
    }
    
    private var moviesList: some View {
        
        List {
            
            ForEach(viewModel.movies) { movie in
                
                Button {
                    coordinator.showMovieDetail(movieId: movie)
                    
                } label: {
                    
                    let model = MovieRowModel(movie: movie)
                    MovieRowView(model: model, isFavorite: viewModel.isFavorite(movie.id)) {
                        viewModel.toggleFavorite(for: movie)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            if viewModel.hasNextPagination {
                loadingView
            }
        }
    }
    
    var loadingView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .task {
            await viewModel.fetchMoreMovies()
        }
    }
}

#Preview {
    MoviesFactory().makeModule(coordinator: AppCoordinator())
}
