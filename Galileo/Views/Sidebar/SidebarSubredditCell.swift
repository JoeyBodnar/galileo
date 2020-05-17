//
//  SidebarSubredditCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/27/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

class SidebarSubredditCell: NSTableCellView {
    
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var iconImageView: NSImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.wantsLayer = true
        iconImageView.layer?.cornerRadius = 10
        iconImageView.layer?.borderColor = NSColor.white.cgColor
        iconImageView.layer?.masksToBounds = true
    }
    
    func configure(subreddit: Subreddit) {
        label.stringValue = subreddit.data.displayName ?? ""
        
        if let url = subreddit.subredditIconUrlString {
            iconImageView.setImage(with: url)
        } else {
            iconImageView.image = NSImage(named: ImageNames.subredditIconDefault)
        }
        
        iconImageView.layer?.borderWidth = 0.5
    }
    
    func configure(subreddit: String, imageName: String) {
        label.stringValue = subreddit
        iconImageView.image = NSImage(named: imageName)?.image(withTintColor: NSColor.red)
        iconImageView.layer?.borderWidth = 0
    }
}
