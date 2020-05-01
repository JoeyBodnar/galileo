//
//  ImageViewButton.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

// need to use this because Gifs requre an imageView but also need button capabilities
class ImageViewButton: NSView {
    private let imageView: NSImageView = NSImageView()
    private let button: ClearButton = ClearButton()
    
    let indicator: NSActivityIndicator = NSActivityIndicator()
    var action: Selector? {
        didSet {
            button.action = action
        }
    }
    
    var target: AnyObject? {
        get {
            return button.target
        }
        set {
            button.target = newValue
        }
    }
    
    var image: NSImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        layoutViews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
     
    func setImage(with urlString: String) {
        if !WindowResizeManager.shared.isMovingMainWindow {
            imageView.animates = false
            imageView.canDrawSubviewsIntoLayer = false
            imageView.setImage(with: urlString)
        }
    }
    
    func setGif(urlString: String) {
        indicator.alphaValue = 1.0
        indicator.startAnimation(self)
        imageView.animates = true
        imageView.canDrawSubviewsIntoLayer = true
        if !WindowResizeManager.shared.isMovingMainWindow {
            imageView.setImage(with: urlString.replacingOccurrences(of: ".gifv", with: ".gif"))
        }
    }
}

// MARK: Layout/Setup
extension ImageViewButton {
    
    private func setupViews() { }
    
    private func layoutViews() {
        indicator.setupForAutolayout(superView: self)
        imageView.setupForAutolayout(superView: self)
        button.setupForAutolayout(superView: self)
        
        indicator.center(in: self)
        indicator.heightAnchor.constraint(equalToConstant: 20).activate()
        indicator.widthAnchor.constraint(equalToConstant: 20).activate()
        imageView.pinToSides(superView: self)
        button.pinToSides(superView: self)
    }
}
