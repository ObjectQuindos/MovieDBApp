//
//  BaseViewModel.swift
//  MoviesApp
//
//  Created by David López on 23/2/25.
//

import Foundation

class BaseViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var error: Error?
    var isEmptySourceData = false
}
