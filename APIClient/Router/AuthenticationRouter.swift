//
//  AuthenticationRouter.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/29/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import WhiteFlowerFactory

enum AuthenticationRouter: Provider {
    
    case getToken
    
    var path: String {
        switch self {
        case .getToken:
            return "\(baseURL)access_token"
        }
    }
    
    var baseURL: String {
        return "https://www.reddit.com/api/v1/"
    }
    
    static var name: String {
        return "PostRouter"
    }
}
