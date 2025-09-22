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

enum Images
{
    static let placeholder = UIImage(named: "avatar-placeholder")
    static let emptyStateLogo = UIImage(named: "empty-state-logo")
}

enum ColorKeys
{
    static let oldGold = UIColor(red: 207/255, green: 181/255, blue: 59/255, alpha: 1.0)
}

enum UrlKeys
{
    static let baseUrl = "http://127.0.0.1:8080"
//    static let baseUrl = "http://localhost:8080"
    static let coursesEndpoint = "/getCourses"
}
