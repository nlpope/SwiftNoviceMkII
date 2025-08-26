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
//        configCollectionView()
//        configDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        logoLauncher = SNLogoLauncher(targetVC: self)
        if PersistenceManager.fetchFirstVisitPostDismissalStatus() { print("true logo status should play"); logoLauncher.configLogoLauncher() }
        else {
//            fetchCoursesFromServer()
//            loadProgressFromCloudKit()
//            configDataSource()
//            configCollectionView()
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
    
    #warning("something about configging the collectionV & dataS blocks the logo")
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
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, Course>(collectionView: collectionView) { (collectionView, indexPath, course) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SNCourseCell.reuseID, for: indexPath) as! SNCourseCell
            
            return cell
        }
    }
    
    
    func fetchCoursesFromServer()
    {
        let testProject1 = CourseProject(name: "proj1", subtitle: "sub1", skills: "swift", link: "www.com", index: 1, completed: false)
        let testCourse = Course(name: "new course", instructor: "james brown", bio: "sing it today", avatarUrl: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%2Fid%2FOIP.6CnF7Q6-QYriUev-yNjjYAHaEK%3Fr%3D0%26pid%3DApi&f=1&ipt=86abf9fcb3dbd4334902f9b624643997652795446a494d035a192bab74395427&ipo=images", courseProjects: [testProject1] )
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
    
    func updateDataSource(with courses: [Course])
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Course>()
        snapshot.appendSections([.main])
        snapshot.appendItems(courses)
        
        DispatchQueue.main.async { self.collectionViewDataSource.apply(snapshot, animatingDifferences: true) }
    }
}
