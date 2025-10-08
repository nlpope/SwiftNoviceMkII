//  File: BookmarksVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 8/31/25.

import UIKit

// THIS WILL LOOK JUST LIKE THE HOMECOURSESVC EXCEPT IT ONLY HOLDS THE BUBBLES OF COURSES THAT HOLD BOOKMARKED (ERGO SEARCHABLE VIA SPOTLIGHT) PROJECTS

class BookmarksVC: SNDataLoadingVC
{
    override func viewDidLoad()
    {
        configNavBar()
    }
    
    private func configNavBar()
    {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
