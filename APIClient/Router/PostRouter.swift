//
//  Router.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/22/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import WhiteFlowerFactory

// get posts by subreddit
// filter subreddit by flair
// filter by sort top, best, hot, new, etc
// paginate
// view a post
// comment on a post
// create a post
// view inbox
// view user
// view user's commments
// view user's posts
// get user subscriptions
// upvote
// downvote
// trending subreddits
// search reddit
// search by subreddit
// save post
// save commment

enum PostRouter: Provider {

    // Public - can be accessed by non logged in users
    case getPostsForSubreddit(subreddit: String, paginator: Paginator, sort: Sort = .hot, isLoggedIn: Bool)
    case getCommentsForPost(subreddit: String, id: String, isLoggedIn: Bool, sort: String?)
    case getMoreComments
    
    // Authenticated - Only accessible to logged in users
    /// the home feed for a signed in user
    case homeFeed(sort: Sort, paginator: Paginator)
    case replyToPost
    case markCommentsRead
    case savePost
    case unsavePost
    
    var path: String {
        switch self {
        case .getPostsForSubreddit(let subreddit, let paginator, let sort, let isLoggedIn):
            let urlString: String = url(isLoggedIn: isLoggedIn)
            if paginator.after != "" {
                return "\(urlString)r/\(subreddit)/\(sort.name).json?\(sort.query)&after=\(paginator.after)"
            } else {
                return "\(urlString)r/\(subreddit)/\(sort.name).json?\(sort.query)"
            }
        case .getCommentsForPost(let subreddit, let id, let isLoggedIn, let sort):
            let urlString: String = url(isLoggedIn: isLoggedIn)
            if let unwrappedSort = sort {
                return "\(urlString)r/\(subreddit)/comments/\(id).json?&limit=250&sort=\(unwrappedSort)"
            } else {
                return "\(urlString)r/\(subreddit)/comments/\(id).json?&limit=250"
            }
        case .getMoreComments:
            return "https://api.reddit.com/api/morechildren"
        case .replyToPost:
            return "\(url(isLoggedIn: true))api/comment"
        case.markCommentsRead:
            return "\(url(isLoggedIn: true))api/read_message"
        case .homeFeed(let sort, let paginator):
            /// cannot get a  user's home feed unless they are logged in
            if paginator.after != "" {
                switch sort {
                case .topAllTime, .topWeekly, .topYearly, .topMonthly:
                    return "\(loggedInUrl)\(sort.name).json?\(sort.query)&after=\(paginator.after)"
                default:
                    return "\(loggedInUrl)\(sort.name).json?\(sort.query)&after=\(paginator.after)"
                }
            } else {
                return "\(loggedInUrl)\(sort.name)/.json?\(sort.query)"
            }
        case .savePost:
            return "\(loggedInUrl)api/save"
        case .unsavePost:
            return "\(loggedInUrl)api/unsave"
        }
    }
    
    /// the actual method used to determind the base url, because it is different if user is logged in
    private func url(isLoggedIn: Bool) -> String {
        return isLoggedIn ? loggedInUrl : "https://www.reddit.com/"
    }
    
    private var loggedInUrl: String {
        return "https://oauth.reddit.com/"
    }
    
    /// Not used. Only here to conform to protocol. Use url(isLoggedIn: Bool) -> String instead
    var baseURL: String { return "" }
    
    static var name: String {
        return "PostRouter"
    }
}
