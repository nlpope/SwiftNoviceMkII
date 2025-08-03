//  File: NetworkManager.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 8/3/25.

import UIKit

class NetworkManager
{
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
}
