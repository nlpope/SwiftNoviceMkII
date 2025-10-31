//  File: User.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct User: Codable, Identifiable
{
    var id: UUID = UUID()
    var avatarURL: String?
    var username: String
    var password: String
}
