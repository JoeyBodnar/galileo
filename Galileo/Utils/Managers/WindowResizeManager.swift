//
//  WindowResizeManager.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class WindowResizeManager {
    
    static let shared: WindowResizeManager = WindowResizeManager()
    
    var isMovingMainWindow: Bool = false
}
