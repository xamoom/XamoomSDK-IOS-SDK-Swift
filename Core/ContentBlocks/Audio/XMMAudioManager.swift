//
//  XMMAudioManager.swift
//  Pods
//
//  Created by Иван Магда on 12.05.2023.
//

import Foundation
import AVFoundation
import UIKit
import MediaPlayer

class XMMAudioManager: XMMPlaybackDelegate, XMMMusicPlayerDelegate {
    
    static let sharedInstances = XMMAudioManager()
    
    private var musicPlayer: XMMMusicPlayer?
    private var mediaFiles = [String: XMMMediaFile]()
    private var currentMediaFile: XMMMediaFile?
    private var seekTimeForControlCenter = 30
    
    private init() {
        musicPlayer = XMMMusicPlayer()
        mediaFiles = [String: XMMMediaFile]()
        musicPlayer?.delegate = self
        setupAudioSession()
        setupControlCenterComands()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            UIApplication.shared.beginReceivingRemoteControlEvents()
        } catch {
            print("Audio Session error \(error)")
        }
    }
    
    private func setupControlCenterComands() {
        let rcc = MPRemoteCommandCenter.shared()
        
        let skipBackwardIntervalCommand = rcc.skipBackwardCommand
        skipBackwardIntervalCommand.isEnabled = true
        skipBackwardIntervalCommand.addTarget(self, action: #selector(skipBackwardEvent))
        skipBackwardIntervalCommand.preferredIntervals = [seekTimeForControlCenter as NSNumber]
        
        let skipForwardIntervalCommand = rcc.skipForwardCommand
        skipForwardIntervalCommand.preferredIntervals = [seekTimeForControlCenter as NSNumber]
        skipForwardIntervalCommand.isEnabled = true
        skipForwardIntervalCommand.addTarget(self, action: #selector(skipForwardEvent(_:)))
        
        let pauseCommand = rcc.pauseCommand
        pauseCommand.isEnabled = true
        pauseCommand.addTarget(self, action: #selector(pauseEvent(_:)))
        
        let playCommand = rcc.playCommand
        playCommand.isEnabled = true
        playCommand.addTarget(self, action: #selector(playEvent(_:)))
    }
    
    func createMediaFile(for ID: String?, url: URL, title: String?, artist: String?) -> XMMMediaFile {
            let newID = ID ?? UUID().uuidString
            
            guard mediaFiles[newID] == nil else {
                return createMediaFile(for: nil, url: url, title: title, artist: artist)
            }
            
            var mediaFile = mediaFiles[ID!]
            
            if mediaFile == nil || mediaFile!.url != url {
                mediaFile = XMMMediaFile(playbackDelegate: self, ID: newID, url: url, title: title, artist: artist, album: nil)
            }
            
            mediaFiles[newID] = mediaFile!
            
            return mediaFile!
        }
}
    
    
    
    
    
    
    
    
    
    
    
    
    func playFile(at ID: String) {
        <#code#>
    }
    
    func pauseFile(at ID: String) {
        <#code#>
    }
    
    func stopFile(at ID: String) {
        <#code#>
    }
    
    func seekForwardFile(at ID: String, time seekTime: Int) {
        <#code#>
    }
    
    func seekBackWardFile(at ID: String, time seekTime: Int) {
        <#code#>
    }
    
    func didLoadAsset(asset: AVAsset) {
        <#code#>
    }
    
    func updatePlaybackPosition(_ time: CMTime) {
        <#code#>
    }
    
    func finishedPlayback() {
        <#code#>
    }
    
    
}
