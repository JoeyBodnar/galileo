//
//  PhotoViewerControllerRootView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/9/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class PhotoViewerControllerRootView: NSView {
    
    private let scrollView: NSScrollView = NSScrollView()
    let imageView: NSImageView = NSImageView()
    
    private let indicator: NSActivityIndicator = NSActivityIndicator()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        layoutViews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension PhotoViewerControllerRootView {
    
    private func setupViews() {
        indicator.alphaValue = 1
        indicator.startAnimation(nil)
        imageView.imageAlignment = .alignCenter
    }
    
    private func layoutViews() {
        indicator.setupForAutolayout(superView: self)
        imageView.setupForAutolayout(superView: self)
        
        imageView.pinToSides(superView: self)
        indicator.center(in: self)
        imageView.heightAnchor.constraint(equalToConstant: 650).activate()
        imageView.widthAnchor.constraint(equalToConstant: 650).activate()
    }
}
