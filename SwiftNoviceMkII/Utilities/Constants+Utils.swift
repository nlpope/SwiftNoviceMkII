//  File: Constants+Utils.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit

enum VideoKeys
{
    static let launchScreen = "launchscreen"
    static let playerLayerName = "PlayerLayerName"
}

enum SFSymbols
{
    static let home = UIImage(systemName: "house")
    static let account = UIImage(systemName: "person.circle")
    static let courses = UIImage(systemName: "books.vertical")
    static let challenges = UIImage(systemName: "figure.badminton")
}

enum PersistenceKeys
{
    static var isVeryFirstVisitStatus = "isVeryFirstVisitStatus"
    static let isFirstVisitPostDismissalStatus = "isFirstVisitPostDismissalStatus"
    static let isLoggedIn = "isLoggedIn"
    static let completedCourses = "completedCourses"
}

enum SaveKeys
{
    static let isFirstVisit = "isFirstVisitStatus"
}
