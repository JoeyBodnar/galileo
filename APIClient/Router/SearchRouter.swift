//
//  SearchRouter.swift
//  APIClient
//
//  Created by Stephen Bodnar on 5/2/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import WhiteFlowerFactory

enum SearchRouter: Provider {

    case search(subreddit: String, query: String, searchOnlySubreddit: Bool)
    
    var path: String {
        switch self {
        case .search(let subreddit, let query, let searchOnlySubreddit):
            let onlySubreddiText: String = searchOnlySubreddit ? "on" : "off"
            return "https://www.reddit.com/r/\(subreddit)/search.json?q=\(query)&restrict_sr=\(onlySubreddiText)&include_over_18=on&sort=relevance"
            
        }
    }
    
    var baseURL: String {
        return "https://oauth.reddit.com/"
    }
    
    static var name: String {
        return "VoteRouter"
    }
}
