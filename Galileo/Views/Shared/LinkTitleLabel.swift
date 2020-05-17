//
//  LinkTitleLabel.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/4/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

/// The title view ued for posts
class LinkTitleLabel: NSTextField {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        font = LinkCellConstants.titleLabelFont
        usesSingleLineMode = false
        cell?.wraps = true
        cell?.isScrollable = false
        isEditable = false
        isSelectable = false
        wantsLayer = true
        backgroundColor = NSColor.clear
        isBezeled = false
        isBordered = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
