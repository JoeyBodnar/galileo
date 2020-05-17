//
//  NSActivityIndicator.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/6/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class NSActivityIndicator: NSProgressIndicator {
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: 20, height: 20)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        style = NSProgressIndicator.Style.spinning
        isIndeterminate = true
        isHidden = false
        usesThreadedAnimation = true
        alphaValue = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
