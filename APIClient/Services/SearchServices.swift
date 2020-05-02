//
//  SearchServices.swift
//  APIClient
//
//  Created by Stephen Bodnar on 5/2/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import WhiteFlowerFactory

public final class SearchServices {
    
    public static let shared: SearchServices = SearchServices()
    
    public func search(text: String, subreddit: String, isSubredditOnly: Bool, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .get, endPoint: SearchRouter.search(subreddit: subreddit, query: text, searchOnlySubreddit: isSubredditOnly))
        APIClient.shared.dataRequest(whiteFlowerRequest: request, forType: SearchResponse.self, completion: completion)
    }
}
