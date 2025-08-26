//  File: Course.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

#warning("include all this info in a liquid glass popup that leads to the courses (identical to swift searcher layout)")
struct Course: Codable, Hashable
{
    let name, instructor, bio: String
    let avatarUrl: String
//    let index: Int
    var courseProjects: [CourseProject]
    
    
    func hash(into hasher: inout Hasher) { hasher.combine(name) }
}
