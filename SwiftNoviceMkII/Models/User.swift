//  File: User.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct User: Codable
{
    //never stored but values injected from user defaults
    //yeah username can be used for the bookmarked courses but what about the completed ones?
    var username: String
    var avatarURL: String? = ""
    var bookmarkedCourses: [Course] 
    var completedCourses: [Course]
    var completedCourseProjects:[CourseProject]
}
