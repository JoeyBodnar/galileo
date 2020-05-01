//
//  MySubredditListResponse.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/26/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

public final class MySubredditListResponse: Decodable {
    public let kind: String
    public let data: ListingResponse<Subreddit>
}
