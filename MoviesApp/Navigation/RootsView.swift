//
//  RootView.swift
//  MoviesApp
//
//  Created by David López on 23/2/25.
//

import SwiftUI

struct MoviesRootView: View {
    
    @ObservedObject var coordinator: AppCoordinator
    @ObservedObject var container: AppDependencyContainer
    
    var body: some View {
        
        NavigationStack(path: $coordinator.navigationPath) {
            
            container.moviesFactory.makeModule(coordinator: coordinator)
                .navigationDestination(for: Route.self) { route in
                    route.destinationView(in: container)
                }
            
            // MARK: - Movies Factory Protocol (Singleton solution) Not Used
            
            /*coordinator.factory.moviesFactory.makeModule()
                .navigationDestination(for: Route.self) { route in
                    route.destinationView(in: container)
                }*/
        }
    }
}

struct FavoritesRootView: View {
    
    @ObservedObject var coordinator: AppCoordinator
    @ObservedObject var container: AppDependencyContainer
    
    var body: some View {
        
        NavigationStack(path: $coordinator.navigationPath) {
            
            container.favoritesFactory.makeFavoritesModule(coordinator: coordinator)
                .navigationDestination(for: Route.self) { route in
                    route.destinationView(in: container)
                }
        }
    }
}
