//  File: Course.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct Course: Identifiable, Codable, CourseItem
{
    var id = UUID()
    let index: Int
    let name, instructor, bio: String
    let avatarUrl: String?
    // course url will be added to the go button in next screen's nav bar
    var courseUrl: String
    var courseProjectsAPIUrl: String
    var isBookmarked: Bool
    var isCompleted: Bool
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case index = "item_index"
        case name
        case instructor
        case bio
        case avatarUrl = "avatar_url"
        case courseUrl = "course_url"
        case courseProjectsAPIUrl = "course_projects_api_url"
        case isBookmarked = "is_bookmarked"
        case isCompleted = "is_completed"
    }
}

#warning("for iOS 15(?) and up, include all this info in a liquid glass popup that leads to the courses (identical to swift searcher layout)")
