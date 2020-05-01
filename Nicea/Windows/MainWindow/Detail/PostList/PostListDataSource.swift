//
//  DetailDataSource.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class PostListDataSource: NSObject, NSTableViewDataSource {

    var posts: [Any] = []
    
    init(posts: [Any]) {
        self.posts = posts
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return posts.count
    }
    
    func invisibleRows(inScrollView scrollView: NSScrollView, endY: CGFloat) -> [NSTableRowView] {
        guard let tableView = scrollView.documentView as? NSTableView else { return [] }
        let contentOffset = endY - scrollView.frame.height
        
        let visibleRect = NSRect(x: 0, y: contentOffset, width: scrollView.frame.width, height: scrollView.frame.height)
        
        let rows = IndexSet(integersIn: 0..<tableView.numberOfRows)
        let rowViews = rows.flatMap { tableView.rowView(atRow: $0, makeIfNecessary: false) as? NSTableRowView }

        return rowViews.filter { rowView -> Bool in
            return !rowView.frame.intersects(visibleRect)
        }
    }
}
