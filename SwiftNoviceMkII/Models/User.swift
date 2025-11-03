//  File: User.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct User: Codable
{
    //never stored but values injected from user defaults
    var username: String
    var avatarURL: String? = ""
    var completedCourses: [Course]
    var completedCourseProjects:[CourseProject]
}
