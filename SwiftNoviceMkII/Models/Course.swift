//  File: Course.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct Course: Identifiable, Codable
{
    var id: Int
    
    let name, instructor, bio: String
    let isBookmarked: Bool
    let avatarUrl: String?
    var courseProjects: [CourseProject]
}

#warning("include all this info in a liquid glass popup that leads to the courses (identical to swift searcher layout)")
