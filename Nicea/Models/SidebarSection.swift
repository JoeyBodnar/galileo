//
//  SidebarSection.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/27/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

enum SectionType {
    case trending
    case mySubscriptions
    case `default`
    
    var name: String {
        switch self {
        case .trending: return "Trending"
        case .mySubscriptions: return "My subscriptions"
        case .default: return "Reddit feeds"
        }
    }
}

final class SidebarSection {
    var sectionType: SectionType
    var children: [Any] = []
    
    init(sectionType: SectionType, children: [Any] = []) {
        self.sectionType = sectionType
        self.children = children
    }
    
    func addChild(child: Subreddit) {
        children.append(child)
    }
}
