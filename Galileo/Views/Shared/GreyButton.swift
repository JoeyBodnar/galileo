//
//  GreyButton.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/17/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

class GreyButton: NSButton {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        wantsLayer = true
        isBordered = false
        layer?.backgroundColor = NSColor.lightGray.cgColor
        layer?.cornerRadius = 4
        contentTintColor = NSColor.white
    }
}
