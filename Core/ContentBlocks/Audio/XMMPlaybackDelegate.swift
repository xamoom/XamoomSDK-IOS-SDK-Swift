//
//  XMMPlaybackDelegate.swift
//  Pods-XamoomSDK_Example
//
//  Created by Иван Магда on 12.05.2023.
//

import Foundation

protocol XMMPlaybackDelegate {
    
    func playFile(at ID: String)
    func pauseFile(at ID: String)
    func stopFile(at ID: String)
    func seekForwardFile(at ID: String, time seekTime: Int)
    func seekBackWardFile(at ID: String, time seekTime: Int)
}
