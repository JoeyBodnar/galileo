//
//  SubredditRouter.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/26/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import WhiteFlowerFactory

enum UserRouter: Provider {

    case mySubscriptions
    case me
    case unreadCommentMail
    case getUserPosts
    case getUserComments(username: String)
    
    var path: String {
        switch self {
        case .mySubscriptions:
           return "\(baseURL)subreddits/mine/subscriber"
        case .me:
            return "\(baseURL)api/v1/me"
        case .unreadCommentMail:
            return "\(baseURL)message/inbox.json"
        case .getUserPosts:
            return ""
        case .getUserComments(let username):
            return "\(baseURL)user/\(username)/comments"
        }
    }
    
    var baseURL: String {
        return "https://oauth.reddit.com/"
    }
    
    static var name: String {
        return "PostRouter"
    }
}
