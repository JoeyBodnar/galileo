//
//  HTTPHeader.swift
//  WhiteFlowerFactory
//
//  Created by Stephen Bodnar on 8/15/19.
//  Copyright © 2019 Stephen Bodnar. All rights reserved.
//

import Foundation

public final class HTTPHeader {
    
    let field: String
    let value: String
    
    public init(field: String, value: String) {
        self.field = field
        self.value = value
    }
}
