//
//  ImageButton.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

/// An NSButton that accepts an image
class ImageButton: NSButton {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        isBordered = false
        imageScaling = .scaleProportionallyUpOrDown
        setButtonType(NSButton.ButtonType.momentaryChange)
        imagePosition = .imageOnly
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
