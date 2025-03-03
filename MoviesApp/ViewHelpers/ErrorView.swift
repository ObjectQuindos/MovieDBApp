//
//  ErrorView.swift
//  MoviesApp
//
//  Created by David López on 22/2/25.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    //let retryAction: () -> Void
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Text("Something went wrong!")
                .font(.title)
            
            Text(error.localizedDescription)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.secondary)
            
            /*Button("Try Again") {
                retryAction()
            }
            .buttonStyle(.borderedProminent)*/
        }
    }
}
