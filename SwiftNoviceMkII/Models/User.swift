//  File: User.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct User: Codable, Identifiable
{
    var id = UUID()
    //re-introducing for avatarURL's inclusion;
    //username n password storage isn't enough for profile pics being apart of it
    //but if i can match against each unique username to find the corresponding unique UUID, I can maybe persist the photo in defaults
    //...while I persist the password in the keychain
    var avatarURL: String?
    var username: String //always unique; no ID prop/Identifiable conformance needed
    var password: String
}
