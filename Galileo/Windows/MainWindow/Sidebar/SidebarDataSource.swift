//
//  SidebarDataSource.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/27/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class SidebarDataSource {
    
    var sections: [SidebarSection] = []
    
    init() { }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let section = item as? SidebarSection {
            return TableViewCells.sidebarSectionHeaderCell(outlineView, text: section.sectionType.name, viewFor: tableColumn, item: item)
        } else if let child = item as? SidebarItem {
            return TableViewCells.sideBarItemCell(outlineView, item: child, viewFor: tableColumn)
        }
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return item is SidebarSection
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let section = item as? SidebarSection {
            return section.children[index]
        }
        
        return sections[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let section = item as? SidebarSection {
            return section.children.count
        }
        return sections.count
    }
}
