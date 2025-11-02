//  File: User.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct User: Codable
{
    var username, password: String //unique identifier for keychain (value = password)
    var avatarURL: String? = ""
}
