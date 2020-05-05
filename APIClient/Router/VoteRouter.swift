//
//  VoteRouter.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/29/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import WhiteFlowerFactory

enum VoteRouter: Provider {

    case vote(id: String, direction: VoteDirection)
    
    var path: String {
        switch self {
        case .vote:
           return "\(baseURL)api/vote"
        }
    }
    
    var baseURL: String {
        return "https://oauth.reddit.com/"
    }
    
    static var name: String {
        return "VoteRouter"
    }
}
