//
//  ControlAccentColorButton.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/17/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class ControlAccentColorButton: NSButton {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        isBordered = false
        layer?.backgroundColor = NSColor.controlAccentColor.cgColor //NSColor(red: 0, green: 110 / 255, blue: 1, alpha: 1).cgColor
        layer?.cornerRadius = 4
        contentTintColor = NSColor.white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
