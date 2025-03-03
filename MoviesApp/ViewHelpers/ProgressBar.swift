//
//  ProgressBar.swift
//  MoviesApp
//
//  Created by David López on 1/3/25.
//

import SwiftUI

struct ProgressBar: View {
    
    let value: Double // Value between 0.0 y 1.0
    var color: Color = .blue
    var height: CGFloat = 8
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack(alignment: .leading) {
                
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(width: geometry.size.width, height: height)
                    .cornerRadius(height / 2)
                
                Rectangle()
                    .foregroundColor(color)
                    .frame(width: CGFloat(value) * geometry.size.width, height: height)
                    .cornerRadius(height / 2)
                    .animation(.linear, value: value)
            }
        }
    }
}
