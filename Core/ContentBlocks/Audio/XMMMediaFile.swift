//
//  XMMMediaFile.swift
//  Pods-XamoomSDK_Example
//
//  Created by Иван Магда on 11.05.2023.
//

import Foundation
import UIKit

class XMMMediaFile: XMMMediaFileDelegate {
    
    let ID: String?
    let url: URL?
    let title: String?
    let artist: String?
    let album: String?
    var playbackPosition: Double?
    var delegate: XMMMediaFileDelegate?
    let playbackDelegate: XMMPlaybackDelegate?
    var playing: Bool = false
    
    init(ID: String, url: URL, title: String, artist: String, album: String, playbackDelegate: XMMPlaybackDelegate!) {
        self.ID = ID
        self.url = url
        self.title = title
        self.artist = artist
        self.album = album
        self.playbackDelegate = playbackDelegate
        self.delegate = self
    }
    
    func start() {
        playbackDelegate?.playFile(at: ID!)
    }
    
    func pause() {
        playbackDelegate?.pauseFile(at: ID!)
    }
    
    func seekForward(_ seekTime: Int) {
        playbackDelegate?.seekForwardFile(at: ID!, time: seekTime)
    }
    
    func seekBackward(_ seekTime: Int) {
        playbackDelegate?.seekBackWardFile(at: ID!, time: seekTime)
    }
    
    func didStart() {
        delegate?.didStart()
        playing = true
    }

    func didPause() {
        delegate?.didPause()
        playing = false
    }

    func didStop() {
        delegate?.didStop()
        playing = false
    }

    func didUpdatePlaybackPosition(_ playbackPosition: Int) {
        self.playbackPosition = Double(playbackPosition)
        delegate?.didUpdatePlaybackPosition(playbackPosition)
    }
}


