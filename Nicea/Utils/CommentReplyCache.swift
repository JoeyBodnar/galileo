//
//  CommentReplyCache.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/17/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

/// Cache for the text users enter as they are replying to comments. Used to maintain correct text while scrolling outlineView
final class CommentReplyCache {
    
    static let shared: CommentReplyCache = CommentReplyCache()
    
    private var cache: NSCache<NSString, NSString> = NSCache<NSString, NSString>()
    
    func setValue(_ value: String, forKey key: String) {
        let keyAsNSString: NSString = NSString(string: key)
        let valueAsNSString: NSString = NSString(string: value)
        cache.setObject(valueAsNSString, forKey: keyAsNSString)
    }
    
    func value(forKey key: String) -> String? {
        let keyAsNSString: NSString = NSString(string: key)
        if let value = cache.object(forKey: keyAsNSString) {
            return String(value)
        }
        
        return nil
    }
    
    func removeValue(forKey key: String) {
        let keyAsNSString: NSString = NSString(string: key)
        cache.removeObject(forKey: keyAsNSString)
    }
}
