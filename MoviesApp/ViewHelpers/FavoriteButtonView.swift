//
//  FavoriteButtonView.swift
//  MoviesApp
//
//  Created by David López on 3/3/25.
//

import SwiftUI

struct FavoriteButtonModel {
    let isFavorite: Bool
    let title: String
    let iconName: String
    let backgroundColor: Color
}

struct FavoriteButtonView: View {
    
    let model: FavoriteButtonModel
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            
            HStack {
                
                Image(systemName: model.iconName)
                    .font(.system(size: 16))
                Text(model.title)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(model.backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .buttonStyle(PlainButtonStyle())
    }
}

/*#Preview {
    
    VStack(spacing: 20) {
        FavoriteButtonView(
            model: FavoriteButtonModel(
                isFavorite: false,
                title: "Añadir a favoritos",
                iconName: "heart",
                backgroundColor: .blue
            ),
            action: {}
        )
        
        FavoriteButtonView(
            model: FavoriteButtonModel(
                isFavorite: true,
                title: "Eliminar de favoritos",
                iconName: "heart.fill",
                backgroundColor: .red
            ),
            action: {}
        )
    }
    .padding()
    .previewLayout(.sizeThatFits)
}
*/
