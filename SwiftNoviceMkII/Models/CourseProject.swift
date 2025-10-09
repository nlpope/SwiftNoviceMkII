//  File: CourseProject.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct CourseProject: Identifiable, Codable
{
    var id: UUID?
    let index: Int
    let title, subtitle, skills, link: String
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
        case isBookmarked = "is_bookmarked"
        case isCompleted = "is_completed"
    }
}


 
/**
 struct Course: Identifiable, Codable
 {
     var id: UUID?
     let index: Int
     let name, instructor, bio: String
     let avatarUrl: String?
     var courseUrl: String
     var courseProjectsAPIUrl: String
     let isBookmarked: Bool
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
 */
