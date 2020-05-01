//
//  SidebarOutlineView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class SidebarOutlineView: NSOutlineView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        let column: NSTableColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("col1"))
        column.isEditable = false
        column.minWidth = 0
        addTableColumn(column)
        outlineTableColumn = column
        
        register(NSNib(nibNamed: "SidebarSubredditCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SidebarSubredditCell"))
        register(NSNib(nibNamed: "SidebarSectionHeaderCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SidebarSectionHeaderCell"))
        selectionHighlightStyle = .sourceList
        indentationPerLevel = 6.0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
