//
//  MoreCommentResponse.swift
//  APIClient
//
//  Created by Stephen Bodnar on 4/5/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

/*
 More Comment responsee format is like this:
    - json
        - errors:
            things: []
        - data: [Comment]
 **/

internal class MoreCommentResponseParentJSON: Decodable {
    let json: MoreCommentResponseContainer
}

internal class MoreCommentResponseContainer: Decodable {
    let errors: [String]?
    let data: MoreCommentResponseDataContainer
}

internal class MoreCommentResponseDataContainer: Decodable {
    let things: [Comment]
}
