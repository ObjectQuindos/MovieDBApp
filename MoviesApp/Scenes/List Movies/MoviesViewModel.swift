//
//  MoviesViewModel.swift
//  MoviesApp
//
//  Created by David López on 20/2/25.
//

import Foundation

final class MoviesViewModel: BaseViewModel {
    
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var favoriteStatus: [Int: Bool] = [:]
    
    private let interactor: MoviesInteractor
    private let favoritesManager: FavoritesManagerProtocol
    
    // Pagination
    private(set) var currentPage: Int = 1
    private(set) var isPaginating: Bool = false
    private(set) var hasNextPagination = false
    
    var totalPages: Int = 1
    
    init(interactor: MoviesInteractor, favoritesManager: FavoritesManagerProtocol) {
        self.interactor = interactor
        self.favoritesManager = favoritesManager
    }
    
    @MainActor
    func fetchMovies() async {
        
        guard !isLoading else { return }
        
        isLoading = !isPaginating
        error = nil
        
        do {
            let response = try await interactor.getMovies(page: currentPage)
            
            successFetch(response: response)
            updateFavoriteStatus()
            finishLoading()
            
        } catch {
            self.error = error
            finishLoading()
        }
    }
    
    func fetchMoreMovies() async {
        guard hasNextPagination else { return }
        guard !isPaginating else { return }
        
        currentPage += 1
        isPaginating = true
        
        await fetchMovies()
    }
    
    func toggleFavorite(for movie: Movie) {
        let isFavorite = favoritesManager.toggleFavorite(movie)
        favoriteStatus[movie.id] = isFavorite
    }
    
    func isFavorite(_ movieId: Int) -> Bool {
        favoriteStatus[movieId] ?? false
    }
    
    func updateFavoriteStatus() {
        
        let allFavorites = favoritesManager.getAllFavorites()
        let favoriteIds = Set(allFavorites.map { $0.id })
        
        favoriteStatus = movies.reduce(into: [Int: Bool](), { partialResult, movie in
            partialResult[movie.id] = favoriteIds.contains(movie.id)
        })
    }
}

extension MoviesViewModel {
    
    private func successFetch(response: MovieResponse) {
        isEmptySourceData = response.results.isEmpty
        movies.append(contentsOf: response.results)
        hasNextPagination = response.page < response.totalPages
        totalPages = response.totalPages
    }
    
    private func finishLoading() {
        isPaginating = false
        isLoading = false
    }
}

extension MoviesViewModel: ContentStateViewModel {
    
    var contentState: ContentState {
        determineContentState(isLoading: isLoading, error: error, isEmpty: isEmptySourceData, retryAction: nil, retryAsyncAction: { await self.fetchMovies() }, emptyMessage: "No movies available")
    }
}
