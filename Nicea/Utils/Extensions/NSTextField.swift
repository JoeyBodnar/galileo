//
//  NSTextField.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

extension NSTextField {
    
    func bestHeight(for text: String, width: CGFloat, font: NSFont?) -> CGFloat {
        stringValue = text
        self.font = font
        let height = cell?.cellSize(forBounds: NSRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude)).height ?? 25

        return height
    }
 
    func bestHeight(for attributedText: NSAttributedString, width: CGFloat, font: NSFont?) -> CGFloat {
        attributedStringValue = attributedText
        if font != nil {
            self.font = font
        }
        
        let height = cell?.cellSize(forBounds: NSRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude)).height ?? 25

        return height
    }
}

extension NSTextView {
    
    func heightForString(text: String, font: NSFont, width: CGFloat) -> CGFloat {
        let textStorage: NSTextStorage = NSTextStorage(string: text)
        let textContainer: NSTextContainer = NSTextContainer(containerSize: NSSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        let layoutManager: NSLayoutManager = NSLayoutManager()
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, textStorage.length))
        textContainer.lineFragmentPadding = 0
        layoutManager.glyphRange(for: textContainer)
        
        return layoutManager.usedRect(for: textContainer).size.height
    }
    
    func bestHeight(for attributedText: NSAttributedString, width: CGFloat, font: NSFont?) -> CGFloat {
        let textStorage: NSTextStorage = NSTextStorage(attributedString: attributedText)
        let textContainer: NSTextContainer = NSTextContainer(containerSize: NSSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        let layoutManager: NSLayoutManager = NSLayoutManager()
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        if font != nil {
            textStorage.addAttribute(NSAttributedString.Key.font, value: font!, range: NSMakeRange(0, textStorage.length))
        }
        textContainer.lineFragmentPadding = 0
        layoutManager.glyphRange(for: textContainer)
        
        return layoutManager.usedRect(for: textContainer).size.height
    }
}
