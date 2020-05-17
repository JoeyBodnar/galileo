//
//  VideoView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/9/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import AVFoundation
import WebKit

struct VideoViewItem {
    let isYoutube: Bool
    let url: URL
    let duration: TimeInterval
    let rect: NSRect
}

/// Plays videos
final class VideoView: NSView {
    
    private var player: AVPlayer!
    private let playerLayer: AVPlayerLayer = AVPlayerLayer()
    
    private let playPauseButton: ImageButton = ImageButton()
    private let timeLabel: NSLabel = NSLabel()
    private var webView: WKWebView?
    
    var isPlaying: Bool = false
    var isYoutube: Bool = false
    
    var timer: Timer?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        layoutViews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func clear() {
        player?.pause()
        player = nil
        playerLayer.player = nil
        timer?.invalidate()
        timer = nil
        webView?.removeFromSuperview()
        webView = nil
    }
    
    /// called when the view scrolls outs of view, we need to pause and set state
    func pauseForScroll() {
        pause()
        isPlaying = false
    }
    
    func setup(item: VideoViewItem) {
        if item.isYoutube {
            setupIsYoutube(item: item)
        } else {
            setupNotYoutube(item: item)
        }
    }
    
    func setupIsYoutube(item: VideoViewItem) {
        webView = WKWebView()
        webView?.setupForAutolayout(superView: self)
        webView?.pinToSides(superView: self)
        webView?.load(URLRequest(url: item.url))
    }
    
    func setupNotYoutube(item: VideoViewItem) {
        playerLayer.frame = item.rect
        playerLayer.backgroundColor = NSColor.lightGray.withAlphaComponent(0.3).cgColor
        
        let asset: AVURLAsset = AVURLAsset(url: item.url)
        
        self.player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        self.playerLayer.player = self.player
        player.automaticallyWaitsToMinimizeStalling = false
        self.player.volume = 1.0
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoDidFinish), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.95, repeats: true, block: { [weak self] timer in
            guard let weakSelf = self else { return }
            if let currentTime = weakSelf.player?.currentItem?.currentTime(), let totalDuration = weakSelf.player?.currentItem?.duration {
                let currentSeconds: Float64 = CMTimeGetSeconds(currentTime)
                let totalSeconds: Float64 = CMTimeGetSeconds(totalDuration)
                if totalSeconds.isNaN || currentSeconds.isNaN { return }
                
                weakSelf.timeLabel.stringValue = "\(Int(totalSeconds) - Int(currentSeconds))"
            }
        })
    }
    
    @objc func playPausedPressed() {
        if isPlaying {
            player?.pause()
            playPauseButton.image = NSImage(named: ImageNames.play)
        } else {
            player?.play()
            playPauseButton.image = nil
        }
        
        isPlaying = !isPlaying
    }
    
    func pause() {
        player?.pause()
    }
    
    @objc func videoDidFinish() {
        player?.seek(to: CMTime.zero)
        isPlaying = false
        playPauseButton.image = NSImage(named: ImageNames.play)
    }
}

// MARK: - Layout/Setup
extension VideoView {
    
    private func setupViews() {
        playPauseButton.target = self
        playPauseButton.action = #selector(playPausedPressed)
        
        playPauseButton.wantsLayer = true
        playPauseButton.image = NSImage(named: ImageNames.play)
        playPauseButton.imageScaling = .scaleNone
        timeLabel.alignment = NSTextAlignment.right
        timeLabel.wantsLayer = true
        timeLabel.layer?.backgroundColor = NSColor.lightGray.cgColor
        timeLabel.layer?.cornerRadius = 3
    }
    
    private func layoutViews() {
        wantsLayer = true
        
        timeLabel.setupForAutolayout(superView: self)
        
        layer?.addSublayer(playerLayer)
        
        playPauseButton.setupForAutolayout(superView: self)
        playPauseButton.center(in: self)
        playPauseButton.pinToSides(superView: self)
        
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15).activate()
        timeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).activate()
    }
}
