//
//  NetworkError.swift
//  MoviesApp
//
//  Created by David López on 22/2/25.
//

enum NetworkError: Error {
    case notFound
    case noConnection
    case httpError
    case dataNotFound
    case decodeError
    case unknown
}
