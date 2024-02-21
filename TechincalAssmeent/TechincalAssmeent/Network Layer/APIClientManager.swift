//
//  APIClientManager.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 19/02/2024.
//

import Foundation
import Combine

/// A singleton manager for handling API requests and responses.
final class APIClientManager {
    
    static let shared = APIClientManager()
    
    private init() {}
    
    /// Fetches and decodes data from the specified API endpoint using a GET request.
       ///
       /// - Parameter endPoint: The API endpoint to fetch data from.
       /// - Returns: A publisher that emits the decoded data or an API network error.
    func fetchData<T: Decodable>(endPoint: Endpoint) -> AnyPublisher<T, APINetworkError> {
        
        guard let url = URL(string: endPoint.urlString) else {
            return Fail(error: .invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
        
            .mapError { error in
                .serverError((error as NSError).code)
            }
            .flatMap { data, response -> AnyPublisher<T, APINetworkError> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return Fail(error: .serverError(-1))
                        .eraseToAnyPublisher()
                }

                switch httpResponse.statusCode {
                case 200...299:
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        return Just(decodedData)
                            .setFailureType(to: APINetworkError.self)
                            .eraseToAnyPublisher()
                    } catch {
                        return Fail(error: .decodingError)
                            .eraseToAnyPublisher()
                    }
                default:
                    return Fail(error: .serverError(httpResponse.statusCode))
                        .eraseToAnyPublisher()
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
     
}
