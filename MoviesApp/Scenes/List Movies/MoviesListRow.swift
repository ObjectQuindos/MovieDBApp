//
//  MoviesListRow.swift
//  MoviesApp
//
//  Created by David López on 3/3/25.
//

import SwiftUI

struct MovieRowModel {
    
    let title: String
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    
    init(movie: Movie) {
        self.title = movie.title
        self.overview = movie.overview
        self.releaseDate = movie.releaseDate
        self.voteAverage = movie.voteAverage
    }
}

struct MovieRowView: View {
    
    let model: MovieRowModel
    let isFavorite: Bool
    var onFavoriteToggle: (() -> Void)?
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 8) {
                
                HStack {
                    
                    Text(model.title)
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        onFavoriteToggle?()
                        
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(isFavorite ? .red : .gray)
                            .font(.title2)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text(model.overview)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
                
                HStack {
                    
                    Text(model.releaseDate.formattedDate)
                        .font(.caption)
                    
                    Spacer()
                    
                    HStack {
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(model.voteAverage.formattedRating)
                    }
                    .font(.caption)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
