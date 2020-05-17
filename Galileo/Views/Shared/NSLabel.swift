//
//  NSLabel.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

/// Generic clear, bezel-less textfield
class NSLabel: NSTextField {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        isEditable = false
        isBezeled = false
        isBordered = false
        backgroundColor = NSColor.clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
