//
//  TrendingSubredditsResponse.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/27/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

public final class TrendingSubredditsResponse: Decodable {
    public let subreddits: [String]
    public let commentCount: Int?
    public let commentUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case subreddits = "subreddit_names"
        case commentCount = "comment_count"
        case commentUrl = "comment_url"
    }
}
