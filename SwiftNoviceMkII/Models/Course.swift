//  File: Course.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct Course: Identifiable, Codable
{
    var id: UUID?
    let index: Int
    let name, instructor, bio: String
    let isBookmarked: Bool
    let avatarUrl: String?
    var courseUrl: String
    var courseProjectsAPIUrl: String
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case index = "itemIndex"
        case name
        case instructor
        case bio
        case isBookmarked = "is_Bookmarked"
        case avatarUrl = "avatar_url"
        case courseUrl = "course_url"
        case courseProjectsAPIUrl = "course_projects_url"
    }
}

#warning("for iOS 15(?) and up, include all this info in a liquid glass popup that leads to the courses (identical to swift searcher layout)")
