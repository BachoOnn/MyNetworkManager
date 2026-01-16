//
//  NetworkManager.swift
//  MyNetworkManager
//
//  Created by Bacho on 17.01.26.
//


//
//  NetworkManager.swift
//  MyNetworkManager
//
//  Created by Bacho on 17.01.26.
//

import Foundation

public final class NetworkManager {
    
    // MARK: - Properties
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    // MARK: - Initialization
    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    // MARK: - Generic Fetch
    
    /// Generic fetch function for all network requests
    public func fetch<T: Codable & Sendable, U: Codable>(
        urlString: String,
        method: HTTPMethodType = .get,
        body: U? = nil,
        headers: [String: String]? = nil
    ) async throws -> T {
        // 1. Validate URL
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // 2. Create request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // 3. Add headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // 4. Add body if present
        if let body = body {
            request.httpBody = try encoder.encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // 5. Perform request
        let (data, response) = try await session.data(for: request)
        
        // 6. Validate response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // 7. Check status code
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        
        // 8. Decode and return
        return try decoder.decode(T.self, from: data)
    }
}
```

---

## 🗑️ Remove Protocol

**Delete `Protocol.swift` (NetworkService.swift)** - you don't need it anymore!

---

## 📁 Final Package Structure
```
MyNetworkManager/
├── Package.swift
└── Sources/
    └── MyNetworkManager/
        ├── NetworkManager.swift      ← One class, one method
        ├── NetworkError.swift        ← Error handling
        └── HTTPMethodType.swift      ← HTTP methods