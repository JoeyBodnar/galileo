//
//  APIResponse.swift
//  WhiteFlowerFactory
//
//  Created by Stephen Bodnar on 8/15/19.
//  Copyright © 2019 Stephen Bodnar. All rights reserved.
//

import Foundation

public typealias APIResult = Result<Data?, Error>

/// The response to all API calls
public final class APIResponse {
    
    public var originalRequest: URLRequest? // Requests aborted by invalidURL will not have an originalRequest
    public var dataTaskResponse: DataTaskResponse?
    public var result: APIResult
    
    init(dataTaskResponse: DataTaskResponse?, result: APIResult, originalRequest: URLRequest?) {
        self.dataTaskResponse = dataTaskResponse
        self.result = result
        self.originalRequest = originalRequest
    }
    
    convenience init(data: Data?, response: URLResponse?, error: Error?, originalRequest: URLRequest?) {
        
        let originalResponse = DataTaskResponse(data: data, response: response)
        if let unwrappedError = error {
            self.init(dataTaskResponse: originalResponse, result: .failure(unwrappedError), originalRequest: originalRequest)
            return
        }
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
        
        switch statusCode {
        case 200..<400:
            self.init(dataTaskResponse: originalResponse, result: .success(data ?? Data()), originalRequest: originalRequest)
        case 400:
            let error: APIResult = .failure(NetworkError.badRequest(statusCode))
            self.init(dataTaskResponse: originalResponse, result: error, originalRequest: originalRequest)
        case 401:
            let error: APIResult = .failure(NetworkError.unauthorized(statusCode))
            self.init(dataTaskResponse: originalResponse, result: error, originalRequest: originalRequest)
        case 403:
            let error: APIResult = .failure(NetworkError.forbidden(statusCode))
            self.init(dataTaskResponse: originalResponse, result: error, originalRequest: originalRequest)
        case 404:
            let error: APIResult = .failure(NetworkError.notFound(statusCode))
            self.init(dataTaskResponse: originalResponse, result: error, originalRequest: originalRequest)
        case 405..<500:
            let error: APIResult = .failure(NetworkError.requestFailed(statusCode))
            self.init(dataTaskResponse: originalResponse, result: error, originalRequest: originalRequest)
        case 500..<600: let error: APIResult = .failure(NetworkError.serverError(statusCode))
            self.init(dataTaskResponse: originalResponse, result: error, originalRequest: originalRequest)
        default:
            self.init(dataTaskResponse: originalResponse, result: .failure(NetworkError.badRequest(statusCode)), originalRequest: originalRequest)
        }
    }
    
    public func serializeTo<T: Decodable>(type: T.Type) -> Result<T, Error> {
        let statusCode: Int = (self.dataTaskResponse?.response as? HTTPURLResponse)?.statusCode ?? 500
        
        switch result {
        case .success(let data):
            if statusCode >= 200 && statusCode <= 204 {
                if let unwrappedData = data {
                    do {
                        let decoder = JSONDecoder()
                        let typedObject: T = try decoder.decode(T.self, from: unwrappedData)
                        return .success(typedObject)
                    } catch let error {
                        return Result.failure(error)
                    }
                }
            } else {
                return .failure(NetworkError.parseError)
            }
        case .failure(let error):
            return .failure(error)
        }
        
        return .failure(NetworkError.badRequest(statusCode))
    }
    
    public func isOk() -> Result<Bool, Error> {
        switch result {
        case .success: return Result.success(true)
        case .failure(let error): return Result.failure(error)
        }
    }
}
