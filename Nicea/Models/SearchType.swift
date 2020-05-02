//
//  SearchType.swift
//  Nicea
//
//  Created by Stephen Bodnar on 5/2/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

enum SearchType {
    
    case subreddit
    case allReddit
    
    var title: String {
        switch self {
        case .subreddit: return "this subreddit"
        case .allReddit: return "all reddit"
        }
    }
}
