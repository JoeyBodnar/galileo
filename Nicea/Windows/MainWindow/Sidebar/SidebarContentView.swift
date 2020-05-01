//
//  SidebarContentView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

/// Contains the outline view, scrollview, and clip view
final class SidebarContentView: NSView {
    let outlineView: SidebarOutlineView = SidebarOutlineView()
    private let scrollView: NSScrollView = NSScrollView()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        layoutViews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension SidebarContentView {
    
    private func setupViews() {
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.wantsLayer = true
    }
    
    private func layoutViews() {
        scrollView.setupForAutolayout(superView: self)
        scrollView.addSubview(outlineView)
        
        scrollView.pinToSides(superView: self)
        
        scrollView.documentView = outlineView
        
        outlineView.wantsLayer = true
        outlineView.layer?.backgroundColor = NSColor.green.cgColor
        
        outlineView.headerView = nil
    }
}
