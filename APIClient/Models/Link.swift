//
//  Link.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//
import Foundation

/**
Returns string by replacing NOT ASCII characters with a percent escaped string using UTF8.
If an argument is nil, returns vacant string.
*/
private func convertObjectToEscapedURLString(_ object: AnyObject?) -> String {
    if let urlstring = object as? String {
        return urlstring
    } else {
        return ""
    }
}

// if is image post, has thumbnail, thumbnail_height not nil, post_hint will be "image"
// if is text post, then thumbnail will be "self", but thumbnail_height will be nil, post_hint nil
// if it a linked article (like news), then post_hint is "link"
public class Link: Decodable {
    public let kind: String
    public let data: LinkData
}

public class LinkData: Decodable {
    public var id: String
    public var title: String
    public var selftext: String?
    public var subreddit: String
    public var clicked: Bool = false
    public var name: String
    public var ups: Int = 0
    public var downs: Int = 0
    public var score: Int = 0
    public var hide_score: Bool = false
    public var link_flair_text: String?
    public var thumbnail_height: Int?
    public var thumbnail: String?
    public var post_hint: String?
    public var author: String = ""
    public var created_utc: Int = 0
    public var url: String? = ""
    public var num_comments: Int = 0
    public var preview: LinkDataMediaPreview?
    public var media: Media?
    public var saved: Bool?
    public var likes: Bool?
}

public class LinkDataMediaPreview: Decodable {
    public let images: [LinkDataMediaImages]
    public let redditMediaPreview: RedditVideeo?
    
    enum CodingKeys: String, CodingKey {
        case images = "images"
        case redditMediaPreview = "reddit_video_preview"
    }
}

public class LinkDataMediaImages: Decodable {
    public var resolutions: [LinkDataMediaImageResolutions]
    public let id: String
}

public class LinkDataMediaImageResolutions: Decodable {
    public let url: String
    public let width: Int
    public let height: Int
    
    public var urlRemovingSpecialCharacters: String  {
        return url.replacingOccurrences(of: "&amp;", with: "&")
    }
}
