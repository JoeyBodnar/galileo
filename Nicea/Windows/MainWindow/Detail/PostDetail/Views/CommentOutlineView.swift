//
//  CommentOutlineViewe.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/6/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class CommentOutlineView: NSOutlineView {
    
    override func makeView(withIdentifier identifier: NSUserInterfaceItemIdentifier, owner: Any?) -> NSView? {
        let view = super.makeView(withIdentifier: identifier, owner: owner)

        if identifier == NSOutlineView.disclosureButtonIdentifier {
          if let btnView = view as? NSButton {
            btnView.frame = NSRect(x: 0, y: 0, width: btnView.frame.width, height: btnView.frame.height)
          }
        }
        return view
    }
}
