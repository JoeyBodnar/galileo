//
//  SidebarSearchCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 5/2/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

protocol SidebarSearchCellDelegate: AnyObject {
    
    func sidebarSearchCell(_ sidebarSearchCell: SidebarSearchCell, didStartSearching searchField: NSSearchField)
}

final class SidebarSearchCell: NSTableCellView {
    
    @IBOutlet weak var searchField: NSSearchField!
    
    weak var delegate: SidebarSearchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchField.delegate = self
    }
}

extension SidebarSearchCell: NSSearchFieldDelegate {
    
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        delegate?.sidebarSearchCell(self, didStartSearching: searchField)
        print("searching")
    }
}
