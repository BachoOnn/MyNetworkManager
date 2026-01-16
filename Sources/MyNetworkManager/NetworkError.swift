//
//  NetworkError.swift
//  MyNetworkManager
//
//  Created by Bacho on 17.01.26.
//


//
//  NetworkError.swift
//  MyNetworkManager
//
//  Created by Bacho on 17.01.26.
//

import Foundation

public enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case noData
    case decodingError(Error)
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response format"
        case .statusCode(let code):
            return "Request failed with status code \(code)"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}