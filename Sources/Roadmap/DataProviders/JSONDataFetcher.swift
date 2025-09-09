//
//  JSONDataFetcher.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

struct JSONDataFetcher {
    enum Error: Swift.Error {
        case invalidURL
    }

    private static let urlSession: URLSession = {
        URLSession(configuration: .ephemeral)
    }()

    static func loadJSON<T: Decodable>(url: URL) async throws -> T {
        let data = try await urlSession.data(from: url).0
        return try JSONDecoder().decode(T.self, from: data)
    }

    static func loadJSON<T: Decodable>(request: URLRequest) async throws -> T {
        let data = try await urlSession.data(for: request).0
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    static func loadJSON<T: Decodable>(fromURLString urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw Error.invalidURL
        }
        return try await loadJSON(url: url)
    }
}
