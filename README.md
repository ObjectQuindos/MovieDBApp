# MoviesApp

MoviesApp is a modern iOS application to discover and save trending movies, built with Swift and SwiftUI and following clean architecture principles.

## 📱 Features

- List trending movies with pagination
- Complete details for each movie with scores and visual metrics
- Manage favorite movies with data persistence using SwiftData
- Smooth navigation through TabView and NavigationStack
- Image visualization with different resolutions

## 🏗️ Architecture

The project follows an MVVM (Model-View-ViewModel) architecture with a focus on SOLID principles:

- **Models**: Basic data representation like `Movie`, `MovieResponse`, and `FavoriteMovie`
- **Views**: Modular and reusable UI components in SwiftUI
- **ViewModels**: Presentation logic and data transformation
- **Services**: Network and data

### Application layers

1. **Presentation**: SwiftUI Views and ViewModels
2. **Domain**: Business models and use cases (Interactors)
3. **Data**: Implementation of network services

### Implemented patterns

- **Dependency Injection**: To facilitate testing and decoupling
- **Factory Pattern**: Creation of UI modules
- **Coordinator Pattern**: Centralized navigation management
- **Repository Pattern**: Abstraction of data sources

## 🛠️ Technologies

- **SwiftUI**: Apple's declarative UI framework
- **SwiftData**: Apple's data persistence framework
- **URLSession**: For network communication
- **Concurrency**: Use of async/await for asynchronous operations

## 🚀 Getting started

### Prerequisites

- Xcode 15 or higher
- iOS 17.0 or higher
- Apple developer account (for device testing)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/MoviesApp.git
   cd MoviesApp
   ```

2. Open the project in Xcode:
   ```bash
   open MoviesApp.xcodeproj
   ```

3. Configure the TMDB API Key:
   - Register an account at [The Movie Database](https://www.themoviedb.org)
   - Get an API Key
   - Add the API Key to the Info.plist file with the key `TMDBApiKey`

4. Build and run the app on a simulator or device

## 🧩 Module architecture

The application is organized into independent modules that communicate through well-defined interfaces:

### Movies module
Displays a list of popular movies with infinite pagination and allows navigation to details.

### Favorites module
Manages user-saved movies with persistence using SwiftData.

### Detail module
Presents detailed information about a movie with visual metrics and allows saving it as a favorite.
