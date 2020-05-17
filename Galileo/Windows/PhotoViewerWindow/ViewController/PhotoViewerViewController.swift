//
//  PhotoViewerViewController.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/9/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class PhotoViewerViewController: NSViewController {
    
    private let rootView: PhotoViewerControllerRootView = PhotoViewerControllerRootView()
    
    // set in PostListViewController before opening this window
    var imageUrls: [String] = []
    
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        
        layoutViews()
        setupViews()
    }
}

extension PhotoViewerViewController {
    
    private func setupViews() {
        rootView.imageView.setImage(with: imageUrls[0])
    }
    
    private func layoutViews() {
        rootView.setupForAutolayout(superView: view)
        rootView.pinToSides(superView: view)
    }
}
