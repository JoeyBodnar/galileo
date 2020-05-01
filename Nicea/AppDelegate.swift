//
//  AppDelegate.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/21/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Cocoa
import APIClient
import CocoaMarkdown

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        //print("window is \(window!.frame)")
        /// AppKit setting window size is very bizarre. Cannot set from the storyboard. Does not work unless delayed for a split second.
        /*DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.window?.setFrame(LayoutConstants.defaultMainWindowRect, display: true)
            self.window?.setFrameOriginToPositionWindowInCenterOfScreen()
        }*/
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // In AppKit while using storyboards, actually the viewDidLoad of the app's initial view controller is called before applicationDidFinishLaunching is called, so the project setup code is in SplitViewController viewdidLoad
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

