//
//  PostListType.swift
//  Nicea
//
//  Created by Stephen Bodnar on 5/2/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

/// The main list of posts in PostListViewController/PostListViewModel can have several different types of content
enum PostListType {

    case searchResults
    case subreddit
    case home
}
