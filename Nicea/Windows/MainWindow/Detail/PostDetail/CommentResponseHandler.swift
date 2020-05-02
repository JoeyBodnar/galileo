//
//  CommentResponseHandler.swift
//  Nicea
//
//  Created by Stephen Bodnar on 5/2/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

final class CommentResponseHandler {
    
    private let comments: [Comment]
    private let dataSource: PostDetailDataSource
    
    init(comments: [Comment], dataSource: PostDetailDataSource) {
        self.comments = comments
        self.dataSource = dataSource
    }
    
    
}
