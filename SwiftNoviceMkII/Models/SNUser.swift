//  File: SNUser.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct User: Codable, Hashable
{
    var avatarURL: String
    var username: String
    var password: String
    
    
    func hash(into hasher: inout Hasher) { hasher.combine(username) }
}
