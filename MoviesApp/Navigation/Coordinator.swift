//
//  Coordinator.swift
//  MoviesApp
//
//  Created by David López on 22/2/25.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case movieDetail(Movie)
}

extension Route {
    
    @ViewBuilder
    func destinationView(in container: AppDependencyContainer) -> some View {
        
        switch self {
            
        case .movieDetail(let movie):
            container.movieDetailFactory.makeDetailModule(movie: movie)
        }
    }
}

final class AppCoordinator: ObservableObject {
    
    @Published var navigationPath = NavigationPath()
    /*let factory: AppFactory
    
    init(factory: AppFactory = .shared) {
        self.factory = factory
    }*/
    
    func showMovieDetail(movieId: Movie) {
        navigationPath.append(Route.movieDetail(movieId))
    }
    
    func goBack() {
        navigationPath.removeLast()
    }
        
    func goToRoot() {
        navigationPath = NavigationPath()
    }
}
