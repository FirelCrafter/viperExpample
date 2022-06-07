//
//  NetworkManager.swift
//  VIPER
//
//  Created by Михаил Щербаков on 23.03.2022.
//

import Foundation
import Combine

enum NetworkError: Error {
    case unknown
    case noConnection
    case timeout
    case badRequest
}

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

///  Class that manages API requests
final class NetworkManager {
    
    private static let baseAddress: URL = URL(string: "https://jsonplaceholder.typicode.com")!
    
    var token: String? = nil
    
    private let urlSession: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()
    
    init() {
        
    }
    
    
    private static func mapValuesToQueryItems(_ source: [String: Any?]) -> [URLQueryItem]? {
        
        let queryItems: [URLQueryItem] = source.compactMap { item in
            if let value = item.value {
                return URLQueryItem(name: item.key, value: "\(value)")
            }
            return nil
        }

        if queryItems.isEmpty {
            return nil
        }
        return queryItems
    }
    
    
    func request<P:Codable, Result:Codable>(method: HTTPMethod, path: String, body: P?, headers: [String: Any]? = nil, queryItems: [String: Any?]? = nil) -> AnyPublisher<Result, NetworkError> {
        
        // URLComponents() использовать для формирования ссылки
        let url = Self.baseAddress.appendingPathComponent(path)
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return Fail(outputType: Result.self, failure: NetworkError.badRequest)
                .eraseToAnyPublisher()
        }
        
        if let queryItems = queryItems {
            urlComponents.queryItems = NetworkManager.mapValuesToQueryItems(queryItems)
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                return Fail(outputType: Result.self, failure: NetworkError.unknown).eraseToAnyPublisher()
            }
        }
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authrization")
        }
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Result.self, decoder: JSONDecoder())
            .mapError({ error in
                return .unknown
                // switch в зависимости от ошибки
            })
            .eraseToAnyPublisher()
        
    }
    
}

