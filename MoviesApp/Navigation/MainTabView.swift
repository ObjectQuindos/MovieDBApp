//
//  MainTabView.swift
//  MoviesApp
//
//  Created by David López on 2/3/25.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject private var moviesCoordinator = AppCoordinator()
    @StateObject private var favoritesCoordinator = AppCoordinator()
    @StateObject private var container = AppDependencyContainer()
    
    var body: some View {
        
        TabView {
            
            MoviesRootView(coordinator: moviesCoordinator, container: container)
            .tabItem {
                Label("Películas", systemImage: "film")
            }
            
            FavoritesRootView(coordinator: favoritesCoordinator, container: container)
            .tabItem {
                Label("Favoritos", systemImage: "heart.fill")
            }
        }
    }
}

#Preview {
    MainTabView()
}
