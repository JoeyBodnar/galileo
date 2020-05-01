//
//  LinkType.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

public enum LinkType {
    
    case linkedArticle
    case imageReddit
    case imageImgur
    case gifImgur
    case selfText
    
    /// type for Reddit videos
    case hostedVideo
    
    case youtubeVideo
    
    /// gyfcat is for gifs, but actually they are available from the Reddit API as HSL videos
    case gyfcatVideo
    case richVideoGeneric
    
    /// Reddit API has many different kinds of links and the type of link decides how you access the internal data. the post_hint from reddit helps, but unfortunately is not nearly enough to really determine the kind of post it is
    public init(link: Link) {
        if let hint = link.data.post_hint {
            if hint == "image" {
                self = .imageReddit
            } else if hint == "link" {
                if let url = link.data.url {
                    if url.contains("imgur") && url.contains("gif") {
                        self = .gifImgur
                    } else if url.contains("imgur"){
                        self = .imageImgur
                    } else if url.contains("v.redd.it") {
                        self = .hostedVideo
                    } else { self = .linkedArticle }
                } else { self = .linkedArticle }
            } else if hint == "self" {
                self = .selfText
            } else if hint == "hosted:video" { //reddit native videos
                self = .hostedVideo
            } else if hint == "rich:video" {
                if let type = link.data.media?.type {
                    if type.contains("youtube") {
                        self = .youtubeVideo
                    } else if type.contains("gfycat") {
                        self = .gyfcatVideo
                    } else { self = .richVideoGeneric }
                } else { self = .richVideoGeneric }
            }
            else { self = .linkedArticle }
        } else if let url = link.data.url {
            if url.contains("www.reddit.com") {
                self = .selfText
            } else if url.contains("i.redd.it") {
                self = .imageReddit
            } else if url.contains("i.imgur") {
                self = .imageImgur
            } else if url.contains("v.redd.it") {
                self = .hostedVideo
            } else {
                self = .linkedArticle
            }
        }
        else {
            self = .linkedArticle
        }
    }
}
