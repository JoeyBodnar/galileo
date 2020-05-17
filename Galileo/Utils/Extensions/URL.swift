//
//  String.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/14/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

extension URL {

    func youtubeId(for urlString: String) -> String? {
        guard let url = URL(string: urlString) else { return nil }
        
        if urlString.contains("youtube.com"), let id = queryString(for: "v") {
            return id
        } else if urlString.contains("youtu.be"), let lastPathComponent = url.pathComponents.last  {
            return lastPathComponent
        }
        
        return nil
    }
    
    private func queryString(for key: String) -> String? {
        let components: URLComponents? = URLComponents(string: absoluteString)
        let queryItem: URLQueryItem? = components?.queryItems?.first(where: { queryItem -> Bool in
            return queryItem.name == key
        })
        
        return queryItem?.value
    }
}
