//
//  SubredditRouter.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/27/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

import WhiteFlowerFactory
// https://oauth.reddit.com

enum SubredditRouter: Provider {

    case trendingSubreddits
    case about(subreddit: String)
    
    var path: String {
        switch self {
        case .trendingSubreddits:
           return "\(baseURL)api/trending_subreddits.json"
        case .about(let subreddit):
            return "\(baseURL)r/\(subreddit)/about.json"
        }
    }
    
    var baseURL: String {
        return "https://www.reddit.com/"
    }
    
    static var name: String {
        return "SubredditRouter"
    }
}
