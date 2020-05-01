//
//  SubredditResponse.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/24/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

public final class SubredditResponse: Decodable {
    public let kind: String
    public let data: ListingResponse<Link>
    
    public var paginator: Paginator {
        return Paginator(after: data.after ?? "", before: data.before ?? "", modhash: data.modhash ?? "")
    }
}

public final class ListingResponse<T: Decodable>: Decodable {
    public let modhash: String?
    public let before: String?
    public let after: String?
    public let dist: Int?
    public var children: [T]?
    
    public init(modhash: String?, before: String?, after: String?, dist: Int?, children: [T]?) {
        self.modhash = modhash
        self.before = before
        self.after = after
        self.dist = dist
        self.children = children
    }
}
