//
//  XMMMediaFileDelegate.swift
//  Pods-XamoomSDK_Example
//
//  Created by Иван Магда on 12.05.2023.
//

import Foundation

protocol XMMMediaFileDelegate {
    
    func didStart()
    func didStop()
    func didPause()
    func didUpdatePlaybackPosition(_ playbackPosition: Int)
}
