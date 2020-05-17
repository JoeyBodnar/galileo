//
//  CommentLoadingCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/19/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class CommentLoadingCell: NSTableCellView {
    
    private let label: NSLabel = NSLabel()
    private let indicator: NSActivityIndicator = NSActivityIndicator()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutViews()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indicator.alphaValue = 0
        indicator.stopAnimation(nil)
    }
    
    func configure(itemCount: Int) {
        label.stringValue = "load \(itemCount) more comments"
    }
    
    func startAnimating() {
        indicator.alphaValue = 1
        indicator.startAnimation(nil)
    }
}

// MARK: - Layout/Setup
extension CommentLoadingCell {
    
    private func setupViews() {
        indicator.alphaValue = 0
    }
    
    private func layoutViews() {
        label.setupForAutolayout(superView: self)
        indicator.setupForAutolayout(superView: self)
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).activate()
        label.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        
        indicator.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20).activate()
        indicator.centerYAnchor.constraint(equalTo: label.centerYAnchor).activate()
    }
}
