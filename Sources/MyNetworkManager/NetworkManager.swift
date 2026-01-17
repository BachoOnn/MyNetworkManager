//
//  NetworkManager.swift
//  MyNetworkManager
//
//  Created by Bacho on 17.01.26.
//

import Foundation

public final class NetworkManager {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
        
    /// Generic fetch for requests without body
    public func fetch<T: Codable & Sendable>(
        urlString: String,
        method: HTTPMethodType = .get,
        headers: [String: String]? = nil
    ) async throws -> T {
        try await performRequest(
            urlString: urlString,
            method: method,
            body: nil as String?,
            headers: headers
        )
    }
        
    /// Generic fetch for requests with body
    public func fetch<T: Codable & Sendable, U: Codable>(
        urlString: String,
        method: HTTPMethodType,
        body: U,
        headers: [String: String]? = nil
    ) async throws -> T {
        try await performRequest(
            urlString: urlString,
            method: method,
            body: body,
            headers: headers
        )
    }
        
    private func performRequest<T: Codable & Sendable, U: Codable>(
        urlString: String,
        method: HTTPMethodType,
        body: U?,
        headers: [String: String]?
    ) async throws -> T {
        // Validate URL
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Add headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add body if present
        if let body = body {
            request.httpBody = try encoder.encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Perform request
        let (data, response) = try await session.data(for: request)
        
        // Validate response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // Check status code
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        
        // Decode and return
        return try decoder.decode(T.self, from: data)
    }
}
