//
//  NSImageView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/27/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

extension NSImageView {
    
    func setImage(with urlString: String) {
        let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        if let cachedImage = ImageCacheManager.shared.image(forKey: encodedURL) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
        } else {
            guard let url = URL(string: encodedURL) else { return }
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                if let unwrappedData = data, let image = NSImage(data: unwrappedData) {
                    ImageCacheManager.shared.setItem(image, forKey: encodedURL)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
            task.resume()
        }
    }
}
