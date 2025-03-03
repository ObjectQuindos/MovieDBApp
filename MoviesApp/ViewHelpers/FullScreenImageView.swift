//
//  FullScreenImageView.swift
//  MoviesApp
//
//  Created by David López on 23/2/25.
//

import SwiftUI

struct FullScreenImageView: View {
    
    let imageUrl: URL?
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var offset = CGSize.zero
    @GestureState private var dragState = CGSize.zero
    @State private var lastScaleValue: CGFloat = 1.0
    
    // Zoom values
    private let defaultScale: CGFloat = 1.0
    private let zoomedScale: CGFloat = 2.0
    private let minScale: CGFloat = 0.5
    private let maxScale: CGFloat = 3.0
    
    var body: some View {
        
        ZStack {
            
            Color.black
                .ignoresSafeArea()
                .opacity(0.9)
            
            AsyncImage(url: imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(x: dragState.width + offset.width,
                           y: dragState.height + offset.height)
                    .gesture(
                        SimultaneousGesture(
                            dragGesture,
                            MagnificationGesture()
                                .onChanged { value in
                                    let newScale = lastScaleValue * value
                                    scale = min(max(newScale, minScale), maxScale)
                                }
                                .onEnded { value in
                                    lastScaleValue = scale
                                }
                        )
                    )
                    .onTapGesture(count: 2) {
                        withAnimation(.spring()) {
                            handleDoubleTap()
                        }
                    }
            } placeholder: {
                ProgressView()
            }
            
            VStack {
                
                HStack {
                    
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }
    
    private func handleDoubleTap() {
        
        if scale == defaultScale && offset == .zero {
            scale = zoomedScale
            
        } else {
            resetValues()
        }
        
        lastScaleValue = scale
    }
    
    private func resetValues() {
        scale = defaultScale
        offset = .zero
        lastScaleValue = defaultScale
    }
    
    private var dragGesture: some Gesture {
        
        DragGesture()
            .updating($dragState) { value, state, _ in
                state = value.translation
            }
            .onEnded { value in
                offset.width += value.translation.width
                offset.height += value.translation.height
            }
    }
}
