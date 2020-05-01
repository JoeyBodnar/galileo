//
//  VotableView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/29/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

class VotableView: NSView {
    
    let voteLabel: NSLabel = NSLabel()
    var hideScore: Bool?
    
    /// whether "points" is appended to the score text
    var displayPointsText: Bool = false
    
    var voteCount: Int = -100000 {
        didSet {
            let convertedScore: String = voteCount.convertToScore()
            
            if (hideScore ?? false) {
                voteLabel.stringValue = "•"
            } else if displayPointsText {
                voteLabel.stringValue = "\(convertedScore) points"
            } else {
                voteLabel.stringValue = convertedScore
            }
        }
    }
}
