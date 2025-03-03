//
//  MoviesAppApp.swift
//  MoviesApp
//
//  Created by David López on 19/2/25.
//

import SwiftUI
import SwiftData

@main
struct MoviesApp: App {
    
    var body: some Scene {
        
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    // MARK: - SwiftData Model Container (FavoriteMovie)
    
    var sharedModelContainer: ModelContainer = {
        
        let schema = Schema([
            FavoriteMovie.self,
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
            
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
