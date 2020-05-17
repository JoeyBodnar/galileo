//
//  NSTableView+Extension.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/17/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

extension NSTableView {
    
    func reloadOnMainQueue() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }
}
