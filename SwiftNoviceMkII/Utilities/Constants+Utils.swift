//  File: Constants+Utils.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit

enum APIKeys
{
    static let vaporUrl = "http://127.0.0.1:8080/getCourses"
    static let gitScrpitsUrl = ""
    static let playgrounds1 = ""
}

enum ColorKeys { static let oldGold = UIColor(red: 207/255, green: 181/255, blue: 59/255, alpha: 1.0) }

enum ImageKeys
{
    static let placeholder = UIImage(named: "avatar-placeholder")
    static let emptyStateLogo = UIImage(named: "empty-state-logo")
}

enum PersistenceKeys
{
    static let flickerStatusKey = "flickerStatusKey"
    
    static let existingUsersKey = "existingUsersKey"
    
    static let passwordKey = "passwordKey" //key only, storage = Keychain

    static let loginStatusKey = "loginStatusKey"
}

enum SaveKeys { static let isFirstVisit = "isFirstVisitStatus" }

enum SFSymbolsKeys
{
    static let home = UIImage(systemName: "house")
    static let account = UIImage(systemName: "person.circle")
    static let courses = UIImage(systemName: "books.vertical")
    
    static let bookmarkBlank = UIImage(systemName: "bookmark")
    static let bookmarkFilled = UIImage(systemName: "bookmark.fill")
    static let completeBlank = UIImage(systemName: "checkmark.circle")
    static let completeFilled = UIImage(systemName: "checkmark.circle.fill")
}

enum VideoKeys
{
    static let launchScreen = "launchscreen"
    static let playerLayerName = "PlayerLayerName"
}

// separate from SNError alerts by virtue of being a normal alert where nothing went wrong
enum AlertKeys
{
    // BOOKMARKS
    static let bookmarkSuccessTitle = "Added to bookmarks 🥳"
    static let bookmarkSuccessMsg = "Project successfully added to your bookmarks tab. It is now searchable via your iPhone's Spotlight feature."
    
    static let bookmarkRemovedSuccessTitle = "Removed from bookmarks"
    static let bookmarkRemovedSuccessMsg = "This project was successfully removed from your bookmarks tab. It is no longer searchable via your iPhone's Spotlight feature."
    
    // COMPLETE/INCOMPLETE
    static let completionSuccessTitle = "Marked 'Complete' 🥳"
    static let completionSuccessMsg = "Congratulations. This project has been marked as successfully completed. Keep at it!"
    
    static let incompletionSuccessTitle = "Marked 'Incomplete'"
    static let incompletionSuccessMsg = "This project has now been marked 'incomplete'. You may return to it when ready."
    
    // LOGIN PERMISSIONS
    static let touchIDReason = "Your identity must first be confirmed via Touch ID. May we make this attempt now?"

}
