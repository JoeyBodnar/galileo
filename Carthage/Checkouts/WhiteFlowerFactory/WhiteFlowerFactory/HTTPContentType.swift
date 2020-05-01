//
//  HTTPContentType.swift
//  WhiteFlowerFactory
//
//  Created by Stephen Bodnar on 8/15/19.
//  Copyright © 2019 Stephen Bodnar. All rights reserved.
//

import Foundation

public enum HTTPContentType: String {
    
    /// this is the default encoding for post, put, patch, and delete requests
    case json = "application/json"
    
    /// urlEncoded content type does not support nested dictionaries/arrays at this time,
    /// only flat dictionaries
    case urlEncoded = "application/x-www-form-urlencoded"
    
    case png = "image/png"
    case jpeg = "image/jpeg"
    case mp4 = "video/mp4"
    case xml = "text/xml"
    case textPlain = "text/plain"
    case gif = "image/gif"
}
