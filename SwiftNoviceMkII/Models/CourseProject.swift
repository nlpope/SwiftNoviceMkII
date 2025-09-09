//  File: CourseProject.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct CourseProject: Identifiable, Codable
{
    var id: Int
    
    let title, subtitle, skills, link: String
    var isCompleted: Bool
}
