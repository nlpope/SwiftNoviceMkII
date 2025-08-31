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
    }
    
    
    func configTabBar()
    {
        UITabBar.appearance().tintColor = UIColor(red: 207, green: 181, blue: 59, alpha: 1)
    }
    
    
    func configVCs()
    {
        viewControllers = []
    }
    
    
    func createCoursesNC() -> UINavigationController
    {
        let coursesVC = HomeCoursesVC()
        let homeImage = UIImage(named: "house")
//        coursesVC.title = "Courses"
        coursesVC.tabBarItem = UITabBarItem(title: "Courses", image: homeImage, selectedImage: nil)
    }
    
    
    func createBookmarksNC() -> UINavigationController
    {
        let bookmarksVC =
    }
}
