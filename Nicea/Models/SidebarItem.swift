//
//  SidebarDefaultItem.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/22/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

enum SidebarItem {
    
    case search
    case trendingSubreddit(name: String, image: String)
    case subscriptionSubreddit(subreddit: Subreddit)
    case defaultRedditFeed(name: String, image: String) // "popular", "all", "home"
}
