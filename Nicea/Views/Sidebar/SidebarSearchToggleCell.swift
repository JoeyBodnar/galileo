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
    
    private let allRedditButton: NSButton = NSButton(radioButtonWithTitle: "search all reddit", target: self, action: nil)
    private let thisSubredditButton: NSButton = NSButton(radioButtonWithTitle: "search subreddit", target: self, action: nil)
    
    weak var delegate: SidebarSearchToggleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutViews()
        setupViews()
    }
    
    @objc func radioButtonSelected(sender: NSButton) {
        if allRedditButton.state == .on {
            delegate?.sidebarSearchToggleCell(self, searchTypeDidChange: SearchType.allReddit)
        } else if thisSubredditButton.state == .on {
            delegate?.sidebarSearchToggleCell(self, searchTypeDidChange: SearchType.subreddit)
        }
    }
    
    func configure(item: SearchSubredditItem) {
        switch item {
        case .all: thisSubredditButton.isEnabled = false
        case .subreddit(let subreddit):
            thisSubredditButton.isEnabled = true
            thisSubredditButton.title = "search r/\(subreddit)"
        }
    }
}

extension SidebarSearchToggleCell {
    
    private func setupViews() {
        allRedditButton.target = self
        thisSubredditButton.target = self
        
        allRedditButton.action = #selector(radioButtonSelected(sender:))
        thisSubredditButton.action = #selector(radioButtonSelected(sender:))
        
        allRedditButton.state = .on
    }
    
    private func layoutViews() {
        allRedditButton.setupForAutolayout(superView: self)
        thisSubredditButton.setupForAutolayout(superView: self)
        
        allRedditButton.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        allRedditButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).activate()
        allRedditButton.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        allRedditButton.heightAnchor.constraint(equalToConstant: 22).activate()
        
        thisSubredditButton.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        thisSubredditButton.topAnchor.constraint(equalTo: allRedditButton.bottomAnchor, constant: 5).activate()
        thisSubredditButton.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        thisSubredditButton.heightAnchor.constraint(equalToConstant: 22).activate()
    }
}
