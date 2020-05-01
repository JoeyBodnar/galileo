//
//  UserServices.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/26/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import WhiteFlowerFactory

public class UserServices {
    public static let shared: UserServices = UserServices()
    
    public func getSubscribedSubreddits(authorizationToken: String, completion: @escaping (Result<MySubredditListResponse, Error>) -> Void) {
        let endpoint: UserRouter = UserRouter.mySubscriptions
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .get, endPoint: endpoint, params: nil, headers: nil)
        APIClient.shared.dataRequest(whiteFlowerRequest: request, forType: MySubredditListResponse.self, completion: completion)
    }
    
    public func getUserMailbox(authorizationToken: String, completion: @escaping (Result<MailboxCommentResponse, Error>) -> Void) {
        let endpoint: UserRouter = UserRouter.unreadCommentMail
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .get, endPoint: endpoint, params: nil, headers: nil)
        APIClient.shared.dataRequest(whiteFlowerRequest: request, forType: MailboxCommentResponse.self, completion: completion)
    }
    
    public func getUser(authorizationToken: String, completion: @escaping (Result<User, Error>) -> Void) {
        let endpoint: UserRouter = UserRouter.me
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .get, endPoint: endpoint, params: nil, headers: nil)
        APIClient.shared.dataRequest(whiteFlowerRequest: request, forType: User.self, completion: completion)
    }
    
    public func getUserPosts(authorizationToken: String, username: String, completion: @escaping (Result<ListingResponse<Comment>, Error>) -> Void) {
        APIClient.shared.dataRequest(whiteFlowerRequest: WhiteFlowerRequest(method: .get, endPoint: UserRouter.getUserComments(username: username), params: nil, headers: nil), forType: ListingResponse<Comment>.self, completion: completion)
    }
}
