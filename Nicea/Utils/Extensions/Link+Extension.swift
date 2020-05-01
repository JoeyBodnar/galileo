//
//  Link+Extension.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

extension Link {
    
    var imgSizeForPostDetail: NSSize {
        if let resolution = resolutionForPostDetail {
            let size: NSSize = NSSize(width: resolution.width, height: resolution.height)
            let maxDesiredSize: NSSize = NSSize(width: 600, height: 600)
            return size.fitWithinSizeRespectingAspectRatio(fittingSize: maxDesiredSize)
        }
        
        return NSSize(width: 150, height: 150)
    }
    
    var resolutionForPostDetail: LinkDataMediaImageResolutions? {
        if let images = data.preview?.images {
            let allResolutions = images.flatMap { item -> [LinkDataMediaImageResolutions] in
                return item.resolutions
            }
            if let last = allResolutions.last {
                return last
            }
        }
        
        return nil
    }
    
    /// the size of the image that is used in the post tableview feed. used to set the heigt of the imageview constraint and for calculating cell height
    var imgSizeForCell: NSSize {
        if let resolution = resolutionForCell {
            return NSSize(width: resolution.width, height: resolution.height)
        }
        
        return NSSize(width: 150, height: 150)
    }
    
    var resolutionForCell: LinkDataMediaImageResolutions? {
        if let images = data.preview?.images {
            let allResolutions = images.flatMap { item -> [LinkDataMediaImageResolutions] in
                return item.resolutions
            }
            if let firstOver150 = allResolutions.first(where: { resolution -> Bool in
                return resolution.height >= 150
            }) {
                return firstOver150
            } else if let last = allResolutions.last {
                return last
            }
        }
        
        return nil
    }
    
    /// used for PhotoViewer
    var highResolutionImageUrl: String? {
        if let images = data.preview?.images {
            let allResolutions = images.flatMap { item -> [LinkDataMediaImageResolutions] in
                return item.resolutions
            }
            if let last = allResolutions.last {
                return last.urlRemovingSpecialCharacters
            }
        } else if let url = data.url {
            if url.contains("i.redd.it") || url.contains("i.imgur") {
                return url
            }
        }
        
        return nil
    }
    
    var videoSizeForCell: NSSize {
        let linkType: LinkType = LinkType(link: self)
        switch linkType {
        case .hostedVideo:
            return videoSizeForHostedVideoCell
        case .youtubeVideo:
            return videoSizeForYoutubeCell
        case .gyfcatVideo:
            return gyfcatSizeForCell
        default: return .zero
        }
    }
    
    var youtubeUrl: URL? {
        guard let urlString = data.url, let url = URL(string: urlString) else { return nil }
        
        if let youtubeId = url.youtubeId(for: urlString) {
            let finalUrlString: String = "https://www.youtube.com/embed/\(youtubeId)?feature=oembed&amp;enablejsapi=0"
            
            return URL(string: finalUrlString)
        }
        
        return nil
    }
    
    /// MARK: - Private
    private var gyfcatSizeForCell: NSSize {
        let totalSize: NSSize = NSSize(width: data.media?.oembed?.width ?? 0, height: data.media?.oembed?.height ?? 0)
        return displayedSizeForVideo(defaultSize: totalSize)
    }
    
    private var videoSizeForYoutubeCell: NSSize {
        let totalSize: NSSize = NSSize(width: data.media?.oembed?.width ?? 0, height: data.media?.oembed?.height ?? 0)
        return displayedSizeForVideo(defaultSize: totalSize)
    }
    
    private var videoSizeForHostedVideoCell: NSSize {
        let totalSize: NSSize = NSSize(width: data.media?.redditVideo?.width ?? 0, height: data.media?.redditVideo?.height ?? 0)
        return displayedSizeForVideo(defaultSize: totalSize)
    }
    
    /// takes size and adjusts to fit properly to screen.
    private func displayedSizeForVideo(defaultSize: NSSize) -> NSSize {
        let maxSize: NSSize = NSSize(width: 550, height: 600)
        return defaultSize.fitWithinSizeRespectingAspectRatio(fittingSize: maxSize)
    }
}
