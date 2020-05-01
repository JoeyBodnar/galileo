//
//  OAuthTokenResponse.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/26/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

public final class OAuthTokenResponse: Codable {
    
    public let accessToken: String
    public let refreshToken: String?
    public let expiresIn: Int
    public let scope: String
    public let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case scope = "scope"
        case tokenType = "token_type"
    }
}
