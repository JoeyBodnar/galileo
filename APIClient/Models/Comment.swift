//
//  Comement.swift
//  APIClient
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

/// its `data`property is the comment, `kind` is t1 or `more`
public final class Comment: Decodable {
    public let kind: String
    public let data: CommentData
    
    /// This is not from the API. This keeps track of whether or not we are aactivly replying to the comment
    public var isReplying: Bool? = false
    
    /// whether this item is an actal comment from a user, or a placeholder for loading more comments
    public var isMoreItem: Bool {
        return kind == "more"
    }
    
    public var isTopLevelComment: Bool {
        if let parentId = data.parentId {
            let first2 = String(parentId.prefix(2))
            return first2 == "t3"
        }
        
        return false
    }
    
    public init(kind: String, data: CommentData) {
        self.kind = kind
        self.data = data
    }
}

/// finally. the actual comment.
public final class CommentData: Decodable {
    
    public let id: String?
    public let name: String?
    
    public let author: String?
    public var body: String?
    public let scoreHidden: Bool?
    public let subredditId: String?
    public let createdAt: TimeInterval?
    public let isSubmitter: Bool?
    public var score: Int?
    public var awardCount: Int?
    public let canGild: Bool?
    
    public let authorFullName: String? // format t2_xxxxx
    public let stickied: Bool?
    public let permalink: String?
    public let locked: Bool?
    
    public var replies: CommentReplyData?
    
    public var depth: Int?
    public var saved: Bool?
    
    /// used for `kind` of `more` for loading new comments
    public var moreCount: Int?
    
    public var parentId: String?
    
    /// used for `kind` of `more`, for loading new comments. If this value is nil, then it is a real user comment. Otherwise, just a placeholder
    public var commentChildren: [String]?
    
    public let subject: String?
    public let new: Bool?
    public let linkTitle: String?

    public var likes: Bool?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try? container.decodeIfPresent(String.self, forKey: .id)
        self.name = try? container.decodeIfPresent(String.self, forKey: .name)
        self.author = try? container.decodeIfPresent(String.self, forKey: .author)
        self.body = try? container.decodeIfPresent(String.self, forKey: .body)
        self.scoreHidden = try? container.decodeIfPresent(Bool.self, forKey: .scoreHidden)
        self.subredditId = try? container.decodeIfPresent(String.self, forKey: .subredditId)
        
        self.createdAt = try? container.decodeIfPresent(TimeInterval.self, forKey: .createdAt)
        self.isSubmitter = try? container.decodeIfPresent(Bool.self, forKey: .isSubmitter)
        self.score = try? container.decodeIfPresent(Int.self, forKey: .score)
        self.awardCount = try? container.decodeIfPresent(Int.self, forKey: .awardCount)
        self.canGild = try? container.decodeIfPresent(Bool.self, forKey: .canGild)
        
        self.authorFullName = try? container.decodeIfPresent(String.self, forKey: .authorFullName)
        self.stickied = try? container.decodeIfPresent(Bool.self, forKey: .stickied)
        self.permalink = try? container.decodeIfPresent(String.self, forKey: .permalink)
        self.locked = try? container.decodeIfPresent(Bool.self, forKey: .locked)
        self.depth = try? container.decodeIfPresent(Int.self, forKey: .depth)
        self.commentChildren = try? container.decodeIfPresent([String].self, forKey: .commentChildren)
        
        self.moreCount = try? container.decodeIfPresent(Int.self, forKey: .moreCount)
        self.parentId = try? container.decodeIfPresent(String.self, forKey: .parentId)
        
        self.subject = try? container.decodeIfPresent(String.self, forKey: .subject)
        self.new = try? container.decodeIfPresent(Bool.self, forKey: .new)
        self.linkTitle = try? container.decodeIfPresent(String.self, forKey: .linkTitle)
        
        self.saved = try? container.decodeIfPresent(Bool.self, forKey: .saved)
        self.likes = try? container.decodeIfPresent(Bool.self, forKey: .likes)
        
        // reddit API gives a dictionary object when there are replies. It gives an empty string when no replies.
        // so, have to do custom init here
        if let replies = try? container.decodeIfPresent(CommentReplyData.self, forKey: .replies) {
            self.replies = replies
        } else {
            self.replies = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case author = "author"
        case body = "body"
        case scoreHidden = "score_hidden"
        case subredditId = "subreddit_id"
        case createdAt = "created"
        case isSubmitter = "is_submitter"
        case score = "score"
        case awardCount = "total_awards_received"
        case canGild = "can_gild"
        case authorFullName = "author_fullname"
        case stickied = "stickied"
        case permalink = "permalink"
        case locked = "locked"
        case replies = "replies"
        case depth = "depth"
        case commentChildren = "children"
        case moreCount = "count"
        case parentId = "parent_id"
        case subject = "subject"
        case new = "new"
        case linkTitle = "link_title"
        case saved = "saved"
        case likes = "likes"
    }
    
    public init() {
        self.id = nil
        self.name = nil
        self.author = nil
        self.body = nil
        self.scoreHidden = nil
        self.subredditId = nil
        
        self.createdAt = nil
        self.isSubmitter = nil
        self.score = nil
        self.awardCount = nil
        self.canGild = nil
        
        self.authorFullName = nil
        self.stickied = nil
        self.permalink = nil
        self.locked = nil
        self.depth = nil
        self.commentChildren = nil
        
        self.moreCount = nil
        self.parentId = nil
        
        self.subject = nil
        self.new = nil
        self.linkTitle = nil
        
        self.replies = nil
        
    }
}
