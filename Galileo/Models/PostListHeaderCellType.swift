//
//  PostListHeaderCellType.swift
//  Nicea
//
//  Created by Stephen Bodnar on 5/3/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

enum PostListHeaderCellType {
    
    case subreddit(subreddit: Subreddit)
    case defaultRedditFeed(name: String)
    case searchResults(headerItem: SearchResultHeaderItem)
}
