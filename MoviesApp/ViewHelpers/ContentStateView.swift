//
//  ContentStateView.swift
//  MoviesApp
//
//  Created by David López on 22/2/25.
//

import SwiftUI

/*protocol Factory {
    static func makeModule() -> some View
}*/

// MARK: - Content State

enum ContentState: Equatable {
    
    case loading
    case error(Error, Action?, AsyncAction?)
    case contentView
    case empty(String)
    
    // Equatable: Comparing states
    static func == (lhs: ContentState, rhs: ContentState) -> Bool {
        
        switch (lhs, rhs) {
            
        case (.loading, .loading): return true
            
        case (.contentView, .contentView): return true
            
        case (.empty(let lhsMsg), .empty(let rhsMsg)): return lhsMsg == rhsMsg
            
            // Nota: No comparamos el error específico o la acción, solo el tipo de estado
        case (.error, .error): return true
            
        default: return false
        }
    }
}

// MARK: - View Modifier para ContentState

struct ContentStateModifier<EmptyContent: View, ErrorContent: View, LoadingContent: View>: ViewModifier {
    
    let state: ContentState
    let emptyContent: (String) -> EmptyContent
    let errorContent: (Error, Action?, AsyncAction?) -> ErrorContent
    let loadingContent: () -> LoadingContent
    
    init(
        state: ContentState,
        
        @ViewBuilder emptyContent: @escaping (String) -> EmptyContent = { message in
            
            VStack(spacing: 12) {
            
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            }
            .padding()
        },
        
        @ViewBuilder errorContent: @escaping (Error, Action?, AsyncAction?) -> ErrorContent = { error, retryAction, retryAsyncAction in
             
            
             VStack(spacing: 16) {
                 Image(systemName: "exclamationmark.triangle")
                     .font(.system(size: 40))
                     .foregroundColor(.red)
                 
                 Text("Something went wrong!")
                     .font(.headline)
                 
                 Text(error.localizedDescription)
                     .font(.subheadline)
                     .multilineTextAlignment(.center)
                     .padding(.horizontal)
                     .foregroundColor(.secondary)
                 
                 Button("Try Again") {
        
                    if let syncAction = retryAction {
                        syncAction()
                    }
        
                     if let asyncAction = retryAsyncAction {
                        Task { await asyncAction() }
                    }
                 }
                 .buttonStyle(.borderedProminent)
             }
             .padding()
        },
        
        @ViewBuilder loadingContent: @escaping () -> LoadingContent = {
            
            VStack {
                ProgressView()
                    .scaleEffect(1.5)
                
                Text("Loading...")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding(.top)
            }
        }
    ) {
        self.state = state
        self.emptyContent = emptyContent
        self.errorContent = errorContent
        self.loadingContent = loadingContent
    }
    
    func body(content: Content) -> some View {
        
        ZStack {
            
            switch state {
                
            case .loading:
                loadingContent()
                
            case .error(let error, let retryAction, let retryAsyncAction):
                errorContent(error, retryAction, retryAsyncAction)
                
            case .empty(let message):
                emptyContent(message)
                
            case .contentView:
                content
            }
        }
    }
}

// MARK: - Extension for ContentState

extension View {
    
    /// Apply state for the view content
    /// - Parameter state: content current state
    /// - Returns: View modified by the state
    
    func contentState(_ state: ContentState) -> some View {
        modifier(ContentStateModifier(state: state))
    }
    
    ///  Apply state for the view content with custom view for every state
    /// - Parameters:
    ///   - state: El estado actual del contenido
    ///   - emptyContent: Custom view for empty state
    ///   - errorContent: Custom view for error state
    ///   - loadingContent: Custom view for loading state
    /// - Returns: View modified by the state
    
    func contentState<Empty: View, Error: View, Loading: View>(
        
        _ state: ContentState,
        @ViewBuilder emptyContent: @escaping (String) -> Empty,
        @ViewBuilder errorContent: @escaping (Swift.Error, Action?, AsyncAction?) -> Error,
        @ViewBuilder loadingContent: @escaping () -> Loading
        
    ) -> some View {
        
        modifier(ContentStateModifier(
            state: state,
            emptyContent: emptyContent,
            errorContent: errorContent,
            loadingContent: loadingContent
        ))
    }
}
