//
//  RequestInterceptor.swift
//  APIClient
//
//  Created by Stephen Bodnar on 4/30/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import WhiteFlowerFactory

struct PendingUnauthorizedRequest<T> {
    let request: WhiteFlowerRequest
    let type: T
    let isDataRequest: Bool
}

internal final class RequestInterceptor {
    
    internal var authToken: String?
    
    private let userAgent: HTTPHeader = HTTPHeader(field: HTTPHeaderField.userAgent, value: "stephen-macbook")
    
    //var pendingUnauthorizedDataRequests: [PendingUnauthorizedRequest<T>] = []
    
    /// Automatically adds User-Agent header to each request. If url endpoint contains "oauth", adds Authorization header. If method is POST, adds url encoded content type
    internal func alteredRequest(fromRequest request: WhiteFlowerRequest) -> WhiteFlowerRequest {

        // user agent
        if let _ = request.headers {
            request.headers?.append(userAgent)
        } else {
            request.headers = [userAgent]
        }
        
        if let unwrappedToken = authToken {
            if request.urlString.contains("oauth") {
                request.headers?.append(HTTPHeader(field: HTTPHeaderField.authorization, value: "bearer \(unwrappedToken)"))
            }
        }
        
        // encoding for POST requests
        if request.method == .post {
            request.headers?.append(HTTPHeader(field: HTTPHeaderField.contentType, value: HTTPContentType.urlEncoded.rawValue))
        }
        
        return request
    }
}
