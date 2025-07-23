//  File: AVPlayer+Ext.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import AVKit
import AVFoundation

extension AVPlayer
{
    var isPlaying: Bool { return rate != 0 && error == nil } 
}
