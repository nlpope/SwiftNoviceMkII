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
    var dataSource: UICollectionViewDiffableDataSource<Section, SNCourse>!
    var logoLauncher: SNLogoLauncher!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        PersistenceManager.isFirstVisitPostDismissal = true
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
        
    }
    
    
    func loadProgressFromCloudKit()
    {
        
    }
}
