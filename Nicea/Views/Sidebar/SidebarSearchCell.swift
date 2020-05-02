//
//  SidebarSearchCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 5/2/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class SidebarSearchCell: NSTableCellView {
    
    @IBOutlet weak var searchField: NSSearchField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchField.delegate = self
    }
}

extension SidebarSearchCell: NSSearchFieldDelegate {
    
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        print("searching")
    }
}
