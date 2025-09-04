//  File: HomeCoursesVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit

struct DataStore
{
    func findCourse(in courses: [Course], with identifier: Int) -> Course?
    {
        var targetCourse: Course? = nil
        for course in courses {
            if course.id == identifier { targetCourse = course }
        }
        return targetCourse
    }
}


class HomeCoursesVC: SNDataLoadingVC, UISearchBarDelegate, UISearchResultsUpdating, UICollectionViewDelegate
{
    private enum Section { case main }
    
    let dataStore = DataStore()
    var courses = [Course]()
    var filteredCourses = [Course]()
    var completedCourses = [Course]()
    var isSearching = false
    var logoLauncher: SNLogoLauncher!
    
    var collectionView: UICollectionView!
    private var courseListDataSource: UICollectionViewDiffableDataSource<Section, Course.ID>!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        PersistenceManager.isFirstVisitPostDismissal = true
        configNavBar()
        configSearchController()
        configCollectionView()
        configDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        if PersistenceManager.fetchFirstVisitPostDismissalStatus() {
            logoLauncher = SNLogoLauncher(targetVC: self)
            logoLauncher.configLogoLauncher()
        }
        else {
            fetchCoursesFromServer()
            loadProgressFromCloudKit()
        }
    }
    
    //-------------------------------------//
    // MARK: - CONFIGURATION
    
    private func configNavBar()
    {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configCollectionView()
    {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnLayout(in: view))
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SNCourseCell.self, forCellWithReuseIdentifier: SNCourseCell.reuseID)
    }
    
    
    private func configDataSource()
    {
        courseListDataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView) {
            [self] (collectionView, indexPath, identifier) -> UICollectionViewCell in
            let course = dataStore.findCourse(in: courses, with: identifier)

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SNCourseCell.reuseID,
                                                          for: indexPath) as! SNCourseCell
            cell.set(course: course!)
            
            return cell
        }
    }
    
    
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
    
    
    func fetchCoursesFromServer()
    {
        showLoadingView()
        courses.removeAll()
        let testProject1 = CourseProject(id: 1, name: "proj1", subtitle: "sub1", skills: "swift", link: "www.com", index: 1, completed: false)
        let testProject2 = CourseProject(id: 2, name: "proj2", subtitle: "sub1z", skills: "swiftz", link: "www.comz", index: 1, completed: false)
        let testProject3 = CourseProject(id: 3, name: "proj2", subtitle: "sub1z", skills: "swiftz", link: "www.comz", index: 1, completed: false)
        
        let testCourse = Course(id: 1, name: "new course", instructor: "james brown", bio: "sing it today", isBookmarked: true, avatarUrl: nil, courseProjects: [testProject1] )
        let testCourse2 = Course(id: 2, name: "new coursez", instructor: "james brownz", bio: "sing it todayz", isBookmarked: false, avatarUrl: nil, courseProjects: [testProject2] )
        let testCourse3 = Course(id: 3, name: "new coursez", instructor: "james brownz", bio: "sing it todayz", isBookmarked: false, avatarUrl: nil, courseProjects: [testProject3] )
        let testCourse4 = Course(id: 4, name: "new coursez", instructor: "james brownz", bio: "sing it todayz", isBookmarked: false, avatarUrl: nil, courseProjects: [testProject3] )
        
        courses += [testCourse, testCourse2, testCourse3, testCourse4]
        
        dismissLoadingView()
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
    // MARK: - DIFFABLE DATASOURCE UPDATES (SNAPSHOTS)
    
    func updateDataSource(with courses: [Course])
    {
        print("inside updateDataSource")
        let courseIds = courses.map { $0.id }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Course.ID>()
        snapshot.appendSections([.main])
        // PROBLEM CHILD
        snapshot.appendItems(courseIds, toSection: .main)
        DispatchQueue.main.async { self.courseListDataSource.apply(snapshot, animatingDifferences: true) }
    }
}
