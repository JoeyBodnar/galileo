//
//  PostListScrollView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/6/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class PostListScrollView: NSScrollView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        hasHorizontalScroller = false
        hasVerticalScroller = true
        contentView.postsBoundsChangedNotifications = true
        wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
