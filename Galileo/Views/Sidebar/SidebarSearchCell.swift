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
    
    private let tableView: NSTableView = NSTableView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchField.delegate = self
    }
}

extension SidebarSearchCell: NSSearchFieldDelegate {
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            if searchField.stringValue.count < 2 { return true}
            delegate?.sidebarSearchCell(self, didStartSearching: searchField)
        }

        return false
    }
}
