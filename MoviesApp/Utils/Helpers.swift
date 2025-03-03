//
//  Utils.swift
//  MoviesApp
//
//  Created by David López on 22/2/25.
//

import Foundation

// Types
typealias JSON = [String : Any]
typealias Action = () -> Void
typealias AsyncAction =  () async -> Void

// Network
typealias HTTPResponse = (data: Data?, response: URLResponse?, error: Error?)
typealias JSONResponse = Result<JSON>
typealias DataResponse = Result<Data?>

enum Result<T> {
    
    case success(T)
    case failure(Error)
    
    init(value: T) {
        self = .success(value)
    }
    
    init(error: Error) {
        self = .failure(error)
    }
}

// Extensions
extension Double {
    
    var formattedRating: String {
        String(format: "%.1f", self)
    }
}

extension Int {
    
    var toDouble: Double {
        Double(self)
    }
}

extension String {
    
    var formattedDate: String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else { return self }
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}
