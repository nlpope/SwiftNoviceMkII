//  File: SNTabBarController.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 8/31/25.

import UIKit

class SNTabBarController: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configTabBar()
        configVCs()
    }
    
    
    func configTabBar()
    {
        UITabBar.appearance().tintColor = ColorKeys.oldGold
    }
    
    
    func configVCs()
    { viewControllers = [createCoursesNC(), createBookmarksNC()] }
    
    
    func createCoursesNC() -> UINavigationController
    {
        let coursesVC = HomeCoursesVC()
        coursesVC.title = "Courses"

        let homeImage = UIImage(named: "house")
        coursesVC.tabBarItem = UITabBarItem(title: "Courses", image: homeImage, selectedImage: nil)
        
        return UINavigationController(rootViewController: coursesVC)
    }
    
    
    func createBookmarksNC() -> UINavigationController
    {
        let bookmarksVC = BookMarksVC()
        bookmarksVC.title = "Bookmarks"
        
        bookmarksVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        
        return UINavigationController(rootViewController: bookmarksVC)
    }
}
