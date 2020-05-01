//
//  Array.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/25/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
