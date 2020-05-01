//
//  Oembed.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//
import Foundation

public final class Oembed: Decodable {
    public let providerUrl: String?
    public let height: Int?
    public let width: Int?
    public let type: String
    public let thumbnailHeight: Int?
    
    enum CodingKeys: String, CodingKey {
        case providerUrl = "provider_url"
        case height = "height"
        case width = "width"
        case type = "type"
        case thumbnailHeight = "thumbnail_height"
    }
}
