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
    
    // source: https://stackoverflow.com/questions/45567363/add-custom-view-from-nib-to-viewcontroller
    static func loadFromNib(nibName: String, owner: Any?) -> NSView? {

        var arrayWithObjects: NSArray?

        let nibLoaded = Bundle.main.loadNibNamed(NSNib.Name(nibName), owner: owner, topLevelObjects: &arrayWithObjects)

        if nibLoaded {
            guard let unwrappedObjectArray = arrayWithObjects else { return nil }
            for object in unwrappedObjectArray {
                if object is NSView {
                    return object as? NSView
                }
            }
            return nil
        } else {
            return nil
        }
    }
}
