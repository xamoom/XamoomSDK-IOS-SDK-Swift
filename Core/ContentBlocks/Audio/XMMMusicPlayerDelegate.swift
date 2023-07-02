//
//  XMMMusicPlayerDelegate.swift
//  Pods
//
//  Created by Иван Магда on 12.05.2023.
//

import AVFoundation
import UIKit


protocol XMMMusicPlayerDelegate {
    func didLoadAsset(asset: AVAsset)
    func updatePlaybackPosition(_ time: CMTime)
    func finishedPlayback()
}
