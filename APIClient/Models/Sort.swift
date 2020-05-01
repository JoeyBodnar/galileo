//
//  Sort.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/22/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

public enum Sort {
    case new
    case topWeekly
    case topMonthly
    case topYearly
    case topAllTime
    case hot
    case rising
    
    /// `new`, `top`, etc
    public var name: String {
        switch self {
        case .new: return "new"
        case .topWeekly, .topMonthly, .topYearly, .topAllTime: return "top"
        case .hot: return "hot"
        case .rising: return "rising"
        }
    }
    
    /// the query string to be appended, it `sort=new` or `t=month`
    internal var query: String {
        switch self {
        case .new: return "sort=new"
        case .topWeekly: return "t=week"
        case .topMonthly: return "t=month"
        case .topYearly: return "t=year"
        case .topAllTime: return "t=all"
        case .hot: return "sort=hot"
        case .rising: return "sort=rising"
        }
    }
}
// https://www.reddit.com/top/?t=month
// https://www.reddit.com/top/?t=year
// https://www.reddit.com/top/?t=all
// https://www.reddit.com/new/.json?sort=new
