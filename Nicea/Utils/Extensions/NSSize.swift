//
//  CGSize.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

extension NSSize {
    
    func fitWithinSizeRespectingAspectRatio(fittingSize: NSSize) -> NSSize {
        let actualHeight: CGFloat = self.height
        let actualWidth: CGFloat = self.width
        
        let maxHeight: CGFloat = fittingSize.height
        let maxWidth: CGFloat = fittingSize.width
        
        let ratio: CGFloat = actualWidth / actualHeight
        
        if actualHeight <= fittingSize.height && actualWidth <= fittingSize.width { // if both smaller, just return self
            return self
        } else if actualHeight > maxHeight && actualWidth >= maxWidth {
            // this can actually return objects with heights larger than the max depending on ratio, but, ehh not that important at the moment.
            let heightDifference: CGFloat = actualHeight - maxHeight
            let widthDifference: CGFloat = actualWidth - maxWidth
            
            if widthDifference > heightDifference {
                return NSSize(width: maxWidth, height: maxWidth / ratio)
            } else {
                return NSSize(width: maxHeight * ratio, height: maxHeight)
            }
            
        } else if actualHeight > maxHeight && actualWidth <= maxWidth { // need to resize width to fit height
            if actualHeight > actualWidth {
                return NSSize(width: maxHeight * ratio, height: maxHeight)
            } else if actualWidth > actualHeight {
                return NSSize(width: maxHeight * ratio, height: maxHeight)
            }
        } else if actualWidth > maxWidth && actualHeight <= maxHeight { // need to resize to fit width
            return NSSize(width: maxWidth, height: maxWidth / ratio)
        }
        
        return self
    }
}
