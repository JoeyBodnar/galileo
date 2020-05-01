//
//  PhotoViewerWindowController.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/9/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

enum MediaType {
    case photo
    case photoAlbum
}

final class PhotoViewerWindowController: NSWindowController {
    
    override init(window: NSWindow?) {
        super.init(window: window)
        DispatchQueue.main.async {
            window?.setFrameOriginToPositionWindowInCenterOfScreen()
            window?.alphaValue = 1
        }
    }
    
    convenience init(imageUrls: [String]) {
        let photoVc = PhotoViewerViewController(nibName: nil, bundle: nil)
        photoVc.imageUrls = imageUrls
        self.init(window: NSWindow(contentViewController: photoVc))
        
        window?.titleVisibility = .hidden;
        window?.titlebarAppearsTransparent = true;
        window?.alphaValue = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
