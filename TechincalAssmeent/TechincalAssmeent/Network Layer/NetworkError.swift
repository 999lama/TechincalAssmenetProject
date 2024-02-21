//
//  NetworkError.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 19/02/2024.
//

import Foundation

/// Errors related to API network operations.
enum APINetworkError: Error {
    /// Indicates an invalid URL with an associated error.
    case invalidURL

    /// Indicates no data was received in the response.
    case noData

    /// Indicates a failure during decoding.
    case decodingError

    /// Indicates a server error with a specific HTTP status code.
    case serverError(Int)
}
