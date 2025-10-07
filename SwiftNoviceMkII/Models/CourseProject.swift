//  File: CourseProject.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct CourseProject: Identifiable, Codable
{
    var id: UUID?
    let index: Int
    
    let title, subtitle, skills, link: String
    var isCompleted: Bool
}

/**
 
 struct Course: Identifiable, Codable
 {
     var id: UUID?
     let index: Int
     let name, instructor, bio: String
     let isBookmarked: Bool
     let avatarUrl: String?
 //    var courseProjects: [CourseProject]
     
     enum CodingKeys: String, CodingKey
     {
         case id
         case index = "itemIndex"
         case name
         case instructor
         case bio
         case isBookmarked = "is_Bookmarked"
         case avatarUrl = "avatar_url"
 //        case courseProjects = "course_projects"
     }
 */
