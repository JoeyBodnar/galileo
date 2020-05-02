//
//  SidebarSearchToggleCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 5/2/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

protocol SidebarSearchToggleCellDelegate: AnyObject {
    
    func sidebarSearchToggleCell(_ sidebarSearchToggleCell: SidebarSearchToggleCell, searchTypeDidChange searchType: SearchType)
}

final class SidebarSearchToggleCell: NSTableCellView {
    
    private let segmentedControl: NSSegmentedControl = NSSegmentedControl()
    
    weak var delegate: SidebarSearchToggleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentedControl.setupForAutolayout(superView: self)
        segmentedControl.pinToSides(superView: self)
        
        segmentedControl.segmentCount = 2
        segmentedControl.setLabel(SearchType.subreddit.title, forSegment: 0)
        segmentedControl.setLabel(SearchType.allReddit.title, forSegment: 1)
        
        segmentedControl.setSelected(true, forSegment: 0)
    }
}
