//
//  NSWindow+Extension.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/19/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

extension NSWindow {
    
    func setFrameOriginToPositionWindowInCenterOfScreen() {
        if let screenSize = screen?.frame.size {
            self.setFrameOrigin(NSPoint(x: (screenSize.width-frame.size.width) / 2, y: (screenSize.height-frame.size.height) / 2))
        }
    }
}
