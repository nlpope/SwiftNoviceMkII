//  File: User.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

struct User: Codable
{
    //yeah username can be used for the bookmarked courses but what about the completed ones?
    var username: String
    var avatarURL: String? = ""
    var courseProgress: [Course] = []
    var courseProjectProgress: [CourseProject] = []
    var firstTimeInHomeVC: Bool = true
    var firstTimeInProjectsVC: Bool = true
}
