//
//  Thing.swift
//  reddift
//
//  Created by sonson on 2015/05/27.
//  Copyright (c) 2015年 sonson. All rights reserved.
//
import Foundation

public protocol Thing: Decodable {
    var id: String { get }
    var name: String { get }
    static var kind: String { get }

    init(id: String)
}
