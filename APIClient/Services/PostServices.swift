//
//  PostServices.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/22/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import WhiteFlowerFactory

public class PostServices {
    
    public static let shared: PostServices = PostServices()
    
    public func getHomeFeed(paginator: Paginator, sort: Sort, completion: @escaping (Result<SubredditResponse, Error>) -> Void) {
        let endpoint: PostRouter = PostRouter.homeFeed(sort: sort, paginator: paginator)
        APIClient.shared.dataRequest(whiteFlowerRequest: WhiteFlowerRequest(method: .get, endPoint: endpoint, params: nil, headers: nil), forType: SubredditResponse.self, completion: completion)
    }
    
    public func getPostsForSubreddit(subreddit: String, isLoggedIn: Bool, paginator: Paginator, sort: Sort, completion: @escaping (Result<SubredditResponse, Error>) -> Void) {
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .get, endPoint: PostRouter.getPostsForSubreddit(subreddit: subreddit, paginator: paginator, sort: sort, isLoggedIn: isLoggedIn), params: nil, headers: nil)
        APIClient.shared.dataRequest(whiteFlowerRequest: request, forType: SubredditResponse.self, completion: completion)
    }
    
    public func trendingSubreddits(completion: @escaping (Result<TrendingSubredditsResponse, Error>) -> Void) {
        APIClient.shared.dataRequest(whiteFlowerRequest: WhiteFlowerRequest(method: .get, endPoint: SubredditRouter.trendingSubreddits), forType: TrendingSubredditsResponse.self, completion: completion)
    }
    
    public func votePost(id: String, direction: VoteDirection, completion: @escaping (Result<Bool, Error>) -> Void) {
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .post, endPoint: VoteRouter.vote(id: id, direction: direction), params: ["id": id, "dir": direction.rawValue], headers: nil)
        APIClient.shared.request(whiteFlowerRequest: request, completion: completion)
    }
    
    public func getAboutSubrddit(subreddit: String, completion: @escaping (Result<Subreddit, Error>) -> Void) {
        APIClient.shared.dataRequest(whiteFlowerRequest: WhiteFlowerRequest(method: .get, endPoint: SubredditRouter.about(subreddit: subreddit)), forType: Subreddit.self, completion: completion)
    }
    
    public func getComments(subreddit: String, articleId: String, isLoggedIn: Bool, completion: @escaping (Result<CommentResponse, Error>) -> Void) {
        APIClient.shared.dataRequest(whiteFlowerRequest: WhiteFlowerRequest(method: .get, endPoint: PostRouter.getCommentsForPost(subreddit: subreddit, id: articleId, isLoggedIn: isLoggedIn), headers: nil), forType: CommentResponse.self, completion: completion)
    }
    
    public func getMoreComments(subreddit: String, parentId: String, childrenIds: [String], completion: @escaping (Result<[Comment], Error>) -> Void) {
        let ids: String = childrenIds.joined(separator: ",")
        let parameters: [String: Any] = ["sort": "best", "api_type": "json", "link_id": parentId, "children": ids, "showmore": true]
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .post, endPoint: PostRouter.getMoreComments, params: parameters, headers: nil)
        APIClient.shared.dataRequest(whiteFlowerRequest: request, forType: MoreCommentResponseParentJSON.self) { result in
            switch result {
            case .success(let commentResponse):
                completion(.success(commentResponse.json.data.things))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func reply(parentId: String, text: String, completion: @escaping(Result<[Comment], Error>) -> Void) {
        let params: [String: Any] = ["api_type": "json", "text": text, "thing_id": parentId]
        let request = WhiteFlowerRequest(method: .post, endPoint: PostRouter.replyToPost, params: params, headers: nil)
        
        APIClient.shared.dataRequest(whiteFlowerRequest: request, forType: MoreCommentResponseParentJSON.self) { result in
            switch result {
            case .success(let commentResponse):
                completion(.success(commentResponse.json.data.things))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func markCommentsRead(ids: [String], completion: @escaping (Result<Bool, Error>) -> Void) {
        let idsAsString: String = ids.joined(separator: ",")
        let endPoint: PostRouter = PostRouter.markCommentsRead
        let params: [String: Any] = ["id": idsAsString]
        let request = WhiteFlowerRequest(method: .post, endPoint: endPoint, params: params, headers: nil)
        
        APIClient.shared.request(whiteFlowerRequest: request, completion: completion)
    }
    
    public func savePost(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        saveOrUnsavePost(id: id, endpoint: PostRouter.savePost, completion: completion)
    }
    
    public func unsavePost(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        saveOrUnsavePost(id: id, endpoint: PostRouter.unsavePost, completion: completion)
    }
    
    internal func saveOrUnsavePost(id: String, endpoint: PostRouter, completion: @escaping (Result<Bool, Error>) -> Void) {
        let params: [String: Any] = ["id": id]
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .post, endPoint: endpoint, params: params, headers: nil)
        APIClient.shared.request(whiteFlowerRequest: request, completion: completion)
    }
    
}
