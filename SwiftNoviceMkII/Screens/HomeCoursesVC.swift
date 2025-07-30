//  File: HomeCoursesVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit

class HomeCoursesVC: SNDataLoadingVC
{
    enum Section { case main }
    
    var courses = [SNCourse]()
    var filteredCourses = [SNCourse]()
    var completedCourses = [SNCourse]()
    var logoLauncher: SNLogoLauncher!
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, SNCourse>!

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        PersistenceManager.isFirstVisitPostDismissal = true
        configureCollectionView()
        // all config calls go here
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        print("view will appear triggered")
        logoLauncher = SNLogoLauncher(targetVC: self)
        if PersistenceManager.fetchFirstVisitPostDismissalStatus() {
            logoLauncher.configLogoLauncher()
        } else {
            fetchCoursesFromServer(); loadProgressFromCloudKit()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) { logoLauncher = nil }
    
    
    deinit { logoLauncher.removeAllAVPlayerLayers() }
    
    //-------------------------------------//
    // MARK: - CONFIGURATION
    
    func fetchCoursesFromServer()
    {
        let testCourse = SNCourse(name: "new course", instructor: "james brown", bio: "sing it today", avatarURL: "avatar.jpg", index: 1, courseProjects: nil)
        courses.append(testCourse)
    }
    
    
    func loadProgressFromCloudKit()
    {
        
    }
    
    
    func configureCollectionView()
    {
        collectionView = UICollectionView(frame: view.bounds)
        
    }
}
