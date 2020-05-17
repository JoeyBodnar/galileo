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
    case search
    
    var name: String {
        switch self {
        case .trending: return "Trending"
        case .mySubscriptions: return "My subscriptions"
        case .default: return "Reddit feeds"
        case .search: return "Search"
        }
    }
}

final class SidebarSection {
    var sectionType: SectionType
    var children: [SidebarItem] = []
    
    init(sectionType: SectionType, children: [SidebarItem] = []) {
        self.sectionType = sectionType
        self.children = children
    }
    
}
