//
//  Paginator.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//
import Foundation

public typealias JSONDictionary = Dictionary<String, AnyObject>

public struct Paginator: Decodable {
    public let after: String
    public let before: String
    public let modhash: String
    
    public init() {
        self.after = ""
        self.before = ""
        self.modhash = ""
    }
    
    public init(after: String, before: String, modhash: String) {
        self.after = after
        self.before = before
        self.modhash = modhash
    }
    
    public var isVacant: Bool {
        if (!after.isEmpty) || (!before.isEmpty) {
            return false
        }
        return true
    }
}
