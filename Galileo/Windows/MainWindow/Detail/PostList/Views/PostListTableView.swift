//
//  PostListTableView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/6/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class PostListTableView: NSTableView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        headerView = nil
        wantsLayer = true
        register(NSNib(nibNamed: CellIdentifiers.LinkArticleCell, bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(CellIdentifiers.LinkArticleCell))
        register(NSNib(nibNamed: CellIdentifiers.LinkImageCell, bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(CellIdentifiers.LinkImageCell))
        register(NSNib(nibNamed: CellIdentifiers.LinkVideoCell, bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(CellIdentifiers.LinkVideoCell))
        register(NSNib(nibNamed: CellIdentifiers.SubredditHeaderCell, bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(CellIdentifiers.SubredditHeaderCell))
        let col = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "col"))
        addTableColumn(col)
        
        gridStyleMask = .solidHorizontalGridLineMask
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
