//
//  Task.swift
//  MoviesApp
//
//  Created by David López on 22/2/25.
//

import Foundation

typealias Headers = [String : String]
typealias Parameters = [String : Any]

protocol APITask {
    var method: HTTPMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: Headers { get }
    var parameters: Parameters { get }
}

extension APITask {
    
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem]? { return nil }
    var headers: Headers { [:] }
    var parameters: [Parameters]? { nil }
    
    func request(baseURL: URL) -> URLRequest {
        let url = setURL(baseURL: baseURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.networkServiceType = .responsiveData
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    private func setURL(baseURL: URL) -> URL? {
        let url = baseURL.appending(path: path)
        
        if let items = queryItems {
            var urlComponents = URLComponents(string: url.absoluteString)
            urlComponents?.queryItems = items
            let url = urlComponents?.url
            
            return url
        }
        
        return url
    }
}

enum HTTPMethod {
    
    case get
    case post
    
    init?(rawValue: String) {
        
        switch rawValue {
            
        case HTTPMethod.get.rawValue:
            self = .get
            
        case HTTPMethod.post.rawValue:
            self = .post
            
        default: return nil
        }
    }
    
    var rawValue: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}
