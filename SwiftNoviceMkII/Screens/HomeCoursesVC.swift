//  File: HomeCoursesVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit

class HomeCoursesVC: SNDataLoadingVC, UISearchBarDelegate, UISearchResultsUpdating
{
    enum Section { case main }
    
    var courses = [SNCourse]()
    var filteredCourses = [SNCourse]()
    var completedCourses = [SNCourse]()
    var isSearching = false
    var logoLauncher: SNLogoLauncher!
    
    var collectionView: UICollectionView!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, SNCourse>!

    
    
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
    
    func configSearchController()
    {
        let mySearchController = UISearchController()
        mySearchController.searchResultsUpdater = self
        mySearchController.searchBar.delegate = self
        mySearchController.searchBar.placeholder = "Search courses"
        mySearchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = mySearchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    func configureCollectionView()
    {
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, SNCourse>(collectionView: collectionView) { (collectionView, indexPath, course) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SNCourseCell
            return cell
        }
    }
    
    
    func fetchCoursesFromServer()
    {
        let testProject1 = SNCourseProject(name: "proj1", subtitle: "sub1", skills: "swift", link: "www.com", index: 1, completed: false)
        let testCourse = SNCourse(name: "new course", instructor: "james brown", bio: "sing it today", avatarURL: "avatar.jpg", courseProjects: [testProject1] )
        courses.append(testCourse)
    }
    
    
    func loadProgressFromCloudKit()
    {
        
    }
    
    //-------------------------------------//
    // MARK: - SEARCH CONTROLLER METHODS
    
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let desiredFilter = searchController.searchBar.text, !desiredFilter.isEmpty
        else { return }
        isSearching = true
        filteredCourses = courses.filter {
            $0.name.lowercased().contains(desiredFilter.lowercased())
            || $0.instructor.lowercased().contains(desiredFilter.lowercased())
            || $0.bio.lowercased().contains(desiredFilter.lowercased())
        }
        updateDataSource(with: filteredCourses)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    { searchBar.resignFirstResponder(); isSearching = false; updateDataSource(with: courses) }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText == "" { isSearching = false; updateDataSource(with: courses) }
        else { isSearching = true }
    }
    
    //-------------------------------------//
    // MARK: - DIFFABLE DATASOURCE UPDATES
    
    func updateDataSource(with courses: [SNCourse])
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SNCourse>()
        snapshot.appendSections([.main])
        snapshot.appendItems(courses)
        
        DispatchQueue.main.async { self.collectionViewDataSource.apply(snapshot, animatingDifferences: true) }
    }
}
