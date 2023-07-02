//
//  XMMMusicPlayer.swift
//  Pods
//
//  Created by Иван Магда on 12.05.2023.
//

import Foundation
import UIKit
import AVFoundation

class XMMMusicPlayer {
    
    private var preparing = false
    private var audioPlayer: AVPlayer
    var delegate: XMMMusicPlayerDelegate?
    
    init() {
        audioPlayer = AVPlayer()
        registerObservers()
    }
    
    init(audioPlayer: AVPlayer) {
        self.audioPlayer = audioPlayer
        registerObservers()
    }
    
    func registerObservers() {
        audioPlayer.addObserver(self as! NSObject, forKeyPath: "status", options: [], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: audioPlayer.currentItem)
        
        weak var weakSelf = self
        audioPlayer.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 60), queue: nil) { _ in
            guard let self = weakSelf else { return }
            if !self.preparing {
                self.delegate?.updatePlaybackPosition(self.audioPlayer.currentTime())
            }
        }
    }
    
    func prepare(with asset: AVURLAsset) {
        preparing = true
        asset.loadValuesAsynchronously(forKeys: ["duration"]) { [weak self] in
            guard let self = self else { return }
            let keys = ["playable"]
            let item = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: keys)
            self.audioPlayer.replaceCurrentItem(with: item)
            if self.audioPlayer.status == .readyToPlay {
                self.delegate?.didLoadAsset(asset: self.audioPlayer.currentItem!.asset)
                self.preparing = false
            }
        }
    }
    
    func observeValueForKeyPass(keyPath: String, object: Any, change: [NSKeyValueChangeKey: Any]) {
        if let audioPlayer = object as? AVPlayer, keyPath == "status" {
            if audioPlayer.status == .failed {
                print("XMMMusicPlayer - AVPlayer Failed")
            } else if audioPlayer.status == .readyToPlay {
                print("XMMMusicPlayer - AVPlayerStatusReadyToPlay")
                delegate?.didLoadAsset(asset: audioPlayer.currentItem!.asset)
                preparing = false
            } else if audioPlayer.status == .unknown {
                print("XMMMusicPlayer - AVPlayer Unknown")
            }
        }
    }
    
    @objc private func itemDidFinishPlaying() {
        pause()
        seekToStart()
        delegate?.finishedPlayback()
    }
    
    func seekToStart() {
        let time = CMTime(value: 0, timescale: audioPlayer.currentTime().timescale)
        audioPlayer.seek(to: time)
    }
    
    //MARK: - Aurioplayer Controls
    
    func play() {
        audioPlayer.play()
    }
    
    func pause() {
        audioPlayer.pause()
    }
    
    func forward(time: TimeInterval) {
        let newTime = CMTimeAdd(audioPlayer.currentTime(), CMTime(seconds: time, preferredTimescale: audioPlayer.currentTime().timescale))
        audioPlayer.seek(to: newTime)
    }
    
    func backward (time: TimeInterval) {
        let newTime = CMTimeSubtract(audioPlayer.currentTime(), CMTime(seconds: time, preferredTimescale: audioPlayer.currentTime().timescale))
        audioPlayer.seek(to: newTime)
    }
}

