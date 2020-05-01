//
//  CommentResponse.swift
//  APIClient
//
//  Created by Stephen Bodnar on 4/4/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

/// wrapper class used to wrap the response from the server.
public final class CommentResponse: Decodable {
    
    public var data: ListingResponse<Comment>?
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case data
    }
    
    public init(from decoder: Decoder) throws {
        guard var container = try? decoder.unkeyedContainer() else {
            return
        }
        
        while !container.isAtEnd {
            guard let itemContainer = try? container.nestedContainer(keyedBy: CodingKeys.self) else {
                return
            }
            do {
                let comment: ListingResponse<Comment> = try itemContainer.decode(ListingResponse<Comment>.self, forKey: .data)
                if let kind = comment.children?.first?.kind  {
                    if kind  == "t1" { self.data = comment }
                }
            } catch let error {
                print("failed creating comment \(error)")
            }
        }
    }
    
}

/// used for nested comment replies. This is a property on Comment.
public final class CommentReplyData: Decodable {
    public let kind: String
    public let data: ListingResponse<Comment>?
    
    public init(kind: String, data: ListingResponse<Comment>?) {
        self.kind = kind
        self.data = data
    }
}
