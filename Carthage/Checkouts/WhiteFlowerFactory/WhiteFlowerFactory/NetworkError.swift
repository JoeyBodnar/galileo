//
//  NetworkError.swift
//  WhiteFlowerFactory
//
//  Created by Stephen Bodnar on 8/15/19.
//  Copyright © 2019 Stephen Bodnar. All rights reserved.
//

import Foundation

/// Possiible network error cases for when requests fail
public enum NetworkError: Error {
    
    case invalidURL(Int) // Int is the status code for all cases
    case requestFailed(Int)
    case serverError(Int)
    case badRequest(Int)
    case unauthorized(Int)
    case notFound(Int)
    case forbidden(Int)
    case parseError

    public var defaultMessage: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .requestFailed: return "Request failed"
        case .serverError: return "Server Error"
        case .badRequest: return "Malformed request"
        case .unauthorized: return "Unuthorized"
        case .notFound: return "Resource not found"
        case .forbidden: return "Forbidden"
        case .parseError: return "Parsing failed"
        }
    }
}
