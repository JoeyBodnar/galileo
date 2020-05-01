//
//  ClearButton.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

/// A NSButton that is clear by default
class ClearButton: NSButton {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        isBordered = false
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
        imagePosition = .imageOnly
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
