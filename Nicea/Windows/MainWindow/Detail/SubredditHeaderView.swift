//
//  SubredditHeaderView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class SubredditHeaderView: NSView {
    let imageView: NSImageView = NSImageView()
    let label: ClearButton = ClearButton()
    
    let sortButton: ClearButton = ClearButton()
    let createPostButton: ClearButton = ClearButton()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        layoutViews()
        setupViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutViews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension SubredditHeaderView {
    
    private func setupViews() {
        sortButton.title = "Sort"
        createPostButton.title = "Create post"
    }
    
    private func layoutViews() {
        sortButton.setupForAutolayout(superView: self)
        label.setupForAutolayout(superView: self)
        createPostButton.setupForAutolayout(superView: self)
        
        label.center(in: self)
        
        sortButton.centerYAnchor.constraint(equalTo: label.centerYAnchor).activate()
        sortButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20).activate()
        
        createPostButton.centerYAnchor.constraint(equalTo: label.centerYAnchor).activate()
        createPostButton.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -20).activate()
        
    }
}
