//
//  DetailMovie.swift
//  MoviesApp
//
//  Created by David López on 22/2/25.
//

import SwiftUI

struct MovieCategoryProgress {
    
    let name: String
    let description: String
    let value: Double
    let color: Color
    let icon: String
    
    func progressNameWithDescription() -> String {
        return "\(self.name): \(self.description)"
    }
}

// MARK: - Movie Detail View

struct MovieDetailScene: View {
    
    @ObservedObject var viewModel: MovieDetailViewModel
    
    var body: some View {
        
        VStack {
            movieContent
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(#colorLiteral(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)))
        }
    }
    
    @ViewBuilder
    private var movieContent: some View {
        
        ScrollView {
            
            VStack(spacing: 16) {
                
                MovieBackdropView(urlLargeSize: viewModel.backdropLargeURL, urlOriginalSize: viewModel.backdropOriginalURL)
                
                MovieHeaderView(model: viewModel.headerModel)
                
                FavoriteButtonView(model: viewModel.favoriteButtonModel, action: {
                    viewModel.toggleFavorite()
                })
                
                MovieVoteAverageView(model: viewModel.voteAverageModel)
                
                CategoryProgressView(progressData: viewModel.popularityCategory)
                CategoryProgressView(progressData: viewModel.voteCountCategory)
                
                MovieOverviewView(overviewText: viewModel.overviewText)
            }
        }
    }
}

// MARK: - Movie Backdrop View

struct MovieBackdropView: View {
    
    let urlLargeSize: URL?
    let urlOriginalSize: URL?
    
    @State private var showFullScreen = false
    
    var body: some View {
        
        if let urlLargeSize {
            
            AsyncImage(url: urlLargeSize) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .onTapGesture {
                        showFullScreen = true
                    }
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
            }
            .fullScreenCover(isPresented: $showFullScreen) {
                FullScreenImageView(imageUrl: urlOriginalSize)
            }
        }
    }
}

// MARK: - Movie Header View

private struct MovieHeaderView: View {
    
    let model: MovieDetailViewModel.MovieHeaderModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                
                Text(model.title)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            HStack {
                
                Text(model.releaseDate.formattedDate)
                Text("•")
                Text(model.language.uppercased())
                Spacer()
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        .padding(.horizontal)
    }
}

// MARK: - Movie Vote Average View

private struct MovieVoteAverageView: View {
    
    let model: MovieDetailViewModel.MovieVoteAverageModel
    
    var body: some View {
        
        CardContainerView {
            
            ZStack {
                
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                
                Circle()
                    .trim(from: 0, to: model.voteAverage / 10)
                    .stroke(Color(#colorLiteral(red: 0.96, green: 0.6, blue: 0.66, alpha: 1)), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                
                Text("\(model.voteAverage.formattedRating)%")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.23, blue: 0.45, alpha: 1)))
            }
            .frame(width: 100, height: 100)
            .padding(.trailing, 20)
            
            VStack(alignment: .leading, spacing: 15) {
                
                Text(model.voteCategoryTitle)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.23, blue: 0.45, alpha: 1)))
                
                Text(model.voteCategorySubtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.23, blue: 0.45, alpha: 1)))
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Movie Category Progress

private struct CategoryProgressView: View {
    
    let progressData: MovieCategoryProgress
    
    var body: some View {
        
        CardContainerView {
            
            ZStack {
                
                Circle()
                    .fill(progressData.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: progressData.icon)
                    .font(.system(size: 20))
                    .foregroundColor(progressData.color)
            }
            .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                
                Text(makeText())
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.23, blue: 0.45, alpha: 1)))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack {
                    
                    Text("\(Int(progressData.value * 100))%")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.23, blue: 0.45, alpha: 1)))
                    
                    ProgressBar(value: progressData.value, color: progressData.color)
                        .padding(.top, 6)
                }
            }
        }
    }
    
    private func makeText() -> String {
        return "\(progressData.name): \(progressData.description)"
    }
}

// MARK: - Movie Overview View

private struct MovieOverviewView: View {
    
    let overviewText: String
    
    var body: some View {
        
        CardContainerView {
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text("Overview")
                    .font(.headline)
                
                Text(overviewText)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailFactory().makeDetailModule(movie: mockMovie)
    }
}
