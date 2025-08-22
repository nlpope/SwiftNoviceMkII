//  File: CourseProject.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct CourseProject: Codable, Hashable
{
    let name, subtitle, skills, link: String
    let index: Int
    var completed: Bool
    
    func hash(into hasher: inout Hasher) { hasher.combine(name) }
}
