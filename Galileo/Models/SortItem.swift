//
//  SortItem.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/23/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

struct SortItemTitles {
    
    static let hot: String = "Hot"
    static let new: String = "New"
    static let rising: String = "Rising"
    static let topWeekly: String = "Top - this week"
    static let topMonthly: String = "Top - this month"
    static let topYearly: String = "Top - this year"
    static let topAllTime: String = "Top - all time"
}

struct MenuSortItem {
    
    let title: String
    let sort: Sort
}
