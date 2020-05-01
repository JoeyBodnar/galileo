//
//  User.swift
//  APIClient
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

public final class User: Decodable {

    public let id: String
    public let isEmployee: Bool
    public let coins: Int
    public let over18: Bool
    public let iconImage: String?
    public let oauthClientId: String?
    public let inboxCount: Int
    public let name: String
    public let commentKarma: Int
    public let linkKarma: Int
    public let createdAt: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case isEmployee = "is_employee"
        case coins = "coins"
        case over18 = "over_18"
        case iconImage = "icon_img"
        case oauthClientId = "oauth_client_id"
        case inboxCount = "inbox_count"
        case name = "name"
        case commentKarma = "comment_karma"
        case linkKarma = "link_karma"
        case createdAt = "created"
    }
    
    static var authToken: String? {
        get {
            if let oauthResponseData = UserDefaults.standard.value(forKey: "oauthResponseKey") as? Data {
                let decoder: JSONDecoder = JSONDecoder()
                return (try? decoder.decode(OAuthTokenResponse.self, from: oauthResponseData))?.accessToken
            }
            
            return nil
        }
    }
}
