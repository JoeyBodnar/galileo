//
//  LayoutExtensions.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/24/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

extension NSLayoutConstraint {
    
    func activate() {
        isActive = true
    }
}

extension NSView {
    
    func setupForAutolayout(superView: NSView) {
        superView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pinToSides(superView: NSView) {
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).activate()
        topAnchor.constraint(equalTo: superView.topAnchor).activate()
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).activate()
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).activate()
    }
    
    func center(in superView: NSView) {
        centerYAnchor.constraint(equalTo: superView.centerYAnchor).activate()
        centerXAnchor.constraint(equalTo: superView.centerXAnchor).activate()
    }
}
