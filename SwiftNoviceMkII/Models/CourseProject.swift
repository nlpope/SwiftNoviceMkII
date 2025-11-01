//  File: CourseProject.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct CourseProject: Identifiable, Codable, CourseItem
{
    var id = UUID()
    let index: Int
    let motherCourse: String
    let title: String
    let subtitle: String?
    let skills: String?
    let projectUrl: String?
    var isBookmarked: Bool
    var isCompleted: Bool
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case index = "item_index"
        case motherCourse = "mother_course"
        case title
        case subtitle
        case skills
        case projectUrl = "project_url"
        case isBookmarked = "is_bookmarked"
        case isCompleted = "is_completed"
    }
}
