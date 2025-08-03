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
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, SNCourse>!

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        PersistenceManager.isFirstVisitPostDismissal = true
//        configureCollectionView()
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
    
    func configureCollectionView()
    {
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, SNCourse>(collectionView: collectionView) { (collectionView, indexPath, course) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SNCourseCell
            #warning("TBC: add .set method for SNCourseCell like in GHFollowers > see avatar image view notes. Manual bookmark = UICollectionViewDiffableDataSource @ 'Then you generate the current state of the data' ")
            
            return cell
        }
    }
    
    
    func fetchCoursesFromServer()
    {
        let testCourse = SNCourse(name: "new course", instructor: "james brown", bio: "sing it today", avatarURL: "avatar.jpg", index: 1, courseProjects: nil)
        courses.append(testCourse)
    }
    
    
    func loadProgressFromCloudKit()
    {
        
    }
}
