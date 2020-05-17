//
//  MainWindowController.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

// is in Main.storyboard
final class MainWindowController: NSWindowController {
    
    // this is called when loading initial view from the storyboard. Not called when loading new tabbed window
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.delegate = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
            self?.window?.setFrame(LayoutConstants.defaultMainWindowRect, display: true)
            self?.window?.setFrameOriginToPositionWindowInCenterOfScreen()
        }
    }
    
    // this is called when loading new tabbed window. Not called when loading initial view from storyboard
    override init(window: NSWindow?) {
        super.init(window: window)
        
    }
    
    // this is called when loading new tabbed window. Not called when loading initial view from storyboard
    convenience init(initialSubreddit: String) {
        let splitViewVc: SplitViewController = SplitViewController()
        splitViewVc.initialSubreddit = initialSubreddit
        self.init(window: NSWindow(contentViewController: splitViewVc))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - NSWindowDelegate
extension MainWindowController: NSWindowDelegate {
    
    func windowWillStartLiveResize(_ notification: Notification) {
        WindowResizeManager.shared.isMovingMainWindow = true
        print("start live resize")
    }
    
    func windowDidEndLiveResize(_ notification: Notification) {
        WindowResizeManager.shared.isMovingMainWindow = false
        print("did end live resize")
    }
}
