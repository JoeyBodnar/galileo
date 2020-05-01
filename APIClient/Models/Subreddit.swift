//
//  Subreddit.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import Foundation

public final class Subreddit: Decodable {
    public let kind: String
    public let data: SubredditData
}

public final class SubredditData: Decodable {
    public let iconSize: [Int]?
    public let title: String
    public let name: String
    public let id: String
    
    public let displayName: String?
    public let iconImage: String?
    public let displayNamePrefixed: String?
    public let publicDescription: String?
    public let headerSize: [Int]?
    public let headerImage: String?
    public let allowsPolls: Bool?
    public let subredditType: String?
    public let over18: Bool?
    public let isCrosspostable: Bool?
    public let userIsSubscriber: Bool?
    public let quarantine: Bool?
    public let subscriberCount: Int?
    public let flairPosition: String?
    public let createdAt: Int?
    public let activeUserCount: Int?
    public let primaryColor: String? // comes as hex
    public let communityIconUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case iconSize = "icon_size"
        case title = "title"
        case name = "name"
        case id = "id"
        case displayName = "display_name"
        case iconImage = "icon_img"
        case displayNamePrefixed = "display_name_prefixed"
        case publicDescription = "public_description"
        case headerSize = "header_size"
        case headerImage = "header_img"
        case allowsPolls = "allows_polls"
        case subredditType = "subreddit_type"
        case over18 = "over18"
        case isCrosspostable = "is_crosspostable_subreddit"
        case userIsSubscriber = "user_is_subscriber"
        case quarantine = "quarantine"
        case subscriberCount = "subscribers"
        case flairPosition = "user_flair_position"
        case createdAt = "created_utc"
        case activeUserCount = "active_user_count"
        case primaryColor = "primary_color"
        case communityIconUrl = "community_icon"
    }
}
