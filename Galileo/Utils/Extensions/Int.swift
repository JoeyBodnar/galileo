//
//  Int.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/1/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

extension Int {
    
    func convertToScore() -> String {
        switch self {
        case -1000..<0:
            return "-\(self)"
        case 0..<1000:
            return "\(self)"
        case 1000..<10000:
            return "\(round((CGFloat(self) / 1000) * 100) / 100)k"
        case 10000..<100000:
            return "\(round((CGFloat(self) / 1000) * 10) / 10)k"
        case 100000..<999999:
            return "\(self / 1000)k"
        default: return "\(self)"
        }
    }
}
