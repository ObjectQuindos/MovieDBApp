//
//  Session.swift
//  MoviesApp
//
//  Created by David López on 23/2/25.
//

import Foundation

final class Session {
    
    private let baseURL: URL
    private let session: URLSession
    
    init(baseURL: URL, session: URLSession) {
        self.baseURL = baseURL
        self.session = session
    }
    
    convenience init(url: URL) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Session.defaultHeaders
        let session = URLSession(configuration: configuration)
        self.init(baseURL: url, session: session)
    }
    
    func request<T: APITask>(with task: T) -> URLRequest {
        return task.request(baseURL: baseURL)
    }
    
    func task(with request: URLRequest, completion: @escaping (HTTPResponse) -> Void) -> URLSessionDataTask {
        
        return session.dataTask(with: request) { data, response, error in
            completion((data, response, error))
        }
    }
}

private extension Session {
    
    static let defaultHeaders: Headers = {
        return ["accept" : "application/json", "Authorization" : APIConfiguration.auth]
    }()
}

final class NetworkEdge {
    
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    convenience init(url: URL) {
        let session = Session(url: url)
        self.init(session: session)
    }
    
    func makeRequest<T: APITask>(_ task: T, completion: @escaping ((Result<Any>) -> Void)) {
        
        let request = session.request(with: task)
        
        let task = session.task(with: request) { response in
            
            var result: Result<Any>
            
            guard let httpResponse = response.response as? HTTPURLResponse else {
                result = .failure(response.error ?? NetworkError.httpError)
                completion(result); return
            }
            
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                result = .failure(response.error ?? NetworkError.httpError)
                completion(result); return
            }
            
            guard let data = response.data else {
                result = .failure(response.error ?? NetworkError.dataNotFound)
                completion(result); return
            }
            
            result = .success(data)
            completion(result)
        }
        
        task.resume()
    }
}
