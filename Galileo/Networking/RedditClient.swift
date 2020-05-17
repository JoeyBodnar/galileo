//
//  WhiteFlower.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/29/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

class RedditClient {
    
    static let shared: RedditClient = RedditClient()
    
    var apiClient: APIClient = APIClient.shared
    
    init() {
        apiClient.delegate = self
    }
    
    func setOAuthTokenResponse(response: OAuthTokenResponse) {
        DefaultsManager.shared.userAuthorizationToken = response.accessToken
        apiClient.authToken = response.accessToken
        
        if response.refreshToken != nil {
            DefaultsManager.shared.userRefreshToken = response.refreshToken
        }
    }
}

extension RedditClient: APIClientDelegate {
    
    func client(_ APIClient: APIClient, didRefreshOAuthToken response: OAuthTokenResponse) {
        setOAuthTokenResponse(response: response)
    }
}

