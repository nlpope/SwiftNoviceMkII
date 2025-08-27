//  File: HomeCoursesVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit

class HomeCoursesVC: SNDataLoadingVC, UISearchBarDelegate, UISearchResultsUpdating, UICollectionViewDelegate
{
    enum Section { case main }
    
    var courses = [Course]()
    var filteredCourses = [Course]()
    var completedCourses = [Course]()
    var isSearching = false
    var logoLauncher: SNLogoLauncher!
    
    var collectionView: UICollectionView!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, Course>!

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        PersistenceManager.isFirstVisitPostDismissal = true
        configSearchController()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        logoLauncher = SNLogoLauncher(targetVC: self)
        if PersistenceManager.fetchFirstVisitPostDismissalStatus() { print("true logo status should play"); logoLauncher.configLogoLauncher() }
        else {
            fetchCoursesFromServer()
            loadProgressFromCloudKit()
            configCollectionView()
            configDataSource()
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
    
    
    func configCollectionView()
    {
        print("configCollectionView accessed")
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnLayout(in: view))
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SNCourseCell.self, forCellWithReuseIdentifier: SNCourseCell.reuseID)
    }
    
    
    func configDataSource()
    {
        print("configDAtasource accessed")
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, Course>(collectionView: collectionView) { (collectionView, indexPath, course) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SNCourseCell.reuseID, for: indexPath) as! SNCourseCell
            
            return cell
        }
    }
    
    
    func fetchCoursesFromServer()
    {
        let testProject1 = CourseProject(name: "proj1", subtitle: "sub1", skills: "swift", link: "www.com", index: 1, completed: false)
        let testProject2 = CourseProject(name: "proj1z", subtitle: "sub1z", skills: "swiftz", link: "www.comz", index: 1, completed: false)
        let testCourse = Course(name: "new course", instructor: "james brown", bio: "sing it today", avatarUrl: "https://www.pinclipart.com/downpngs/ibiiRoi_dummy-profile-image-url-clipart/", courseProjects: [testProject1] )
        let testCourse2 = Course(name: "new coursez", instructor: "james brownz", bio: "sing it todayz", avatarUrl: "https://www.pinclipart.com/downpngs/ibiiRoi_dummy-profile-image-url-clipart/", courseProjects: [testProject2] )
        courses.append(testCourse)
        courses.append(testCourse2)
        updateDataSource(with: courses)
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
    
    func updateDataSource(with courses: [Course])
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Course>()
        snapshot.appendSections([.main])
        snapshot.appendItems(courses)
        
        DispatchQueue.main.async { self.collectionViewDataSource.apply(snapshot, animatingDifferences: true) }
    }
}
