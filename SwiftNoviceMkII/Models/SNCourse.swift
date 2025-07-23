//  File: SNCourse.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct SNCourse: Codable, Hashable
{
    let name, instructor, bio: String
    let avatarURL: String?
    let index: Int
    var courseProjects: [SNCourseProject]
    
    
    func hash(into hasher: inout Hasher) { hasher.combine(name) }
}
