//
//  ImageCacheManager.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class ImageCacheManager {
    
    static let shared: ImageCacheManager = ImageCacheManager()
    
    private let cache: NSCache<NSString, NSImage> = NSCache<NSString, NSImage>()
    
    func image(forKey key: String) -> NSImage? {
        let keyAsNSString =  NSString(string: key)
        return cache.object(forKey: keyAsNSString)
    }
    
    func setItem(_ image: NSImage, forKey key: String) {
        let keyAsNSString =  NSString(string: key)
        cache.setObject(image, forKey: keyAsNSString)
    }
}
