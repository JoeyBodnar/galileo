//
//  Media.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//
import Foundation

public final class Media: Decodable {

    public let isVideo: Bool?
    public let redditVideo: RedditVideeo?
    public let oembed: Oembed?
    
    public let type: String?
    
    enum CodingKeys: String, CodingKey {
        case isVideo = "is_video"
        case redditVideo = "reddit_video"
        case oembed = "oembed"
        case type = "type"
    }
}


public final class RedditVideeo: Decodable {

    public let height: Int?
    public let width: Int?
    public let duration: Int?
    public let isGif: Bool?
    public let url: String?
    
    enum CodingKeys: String, CodingKey {
        case height = "height"
        case width = "width"
        case duration = "duration"
        case isGif = "is_gif"
        case url = "hls_url"
    }
    
}
