//
//  MailboxResponse.swift
//  APIClient
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

public final class MailboxCommentResponse: Decodable {
    public let data: ListingResponse<Comment>
    
    public var containsNewComments: Bool {
        if let _ = data.children?.first(where: { comment -> Bool in
            return comment.data.new ?? false
        })
        { return true }
        
        return false
    }
}
