//
//  Subreddit+Extension.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/23/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

extension Subreddit {
    
    var subredditIconUrlString: String? {
        if let icnImg = data.iconImage, icnImg.count > 0 {
            return icnImg
        } else if let headerImg = data.headerImage, headerImg.count > 0 {
            return headerImg
        } else if let commnityIcon = data.communityIconUrl, commnityIcon.count > 0 {
            return commnityIcon
        }
        
        return nil
    }
    
    var infoText: String {
        if let subscriberCount = data.subscriberCount, let activeUserCount = data.activeUserCount {
            return "\(subscriberCount.convertToScore()) subscribers - \(activeUserCount) active"
        }
        
        return ""
    }
}
