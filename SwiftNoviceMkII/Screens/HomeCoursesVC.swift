//  File: HomeCoursesVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit

class HomeCoursesVC: SNDataLoadingVC, UISearchBarDelegate, UISearchResultsUpdating, UICollectionViewDelegate
{
    private enum Section { case main }
    
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
        configSearchController()
        configCollectionView()
        configDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        logoLauncher = SNLogoLauncher(targetVC: self)
        if PersistenceManager.fetchFirstVisitPostDismissalStatus() { print("true logo status should play"); logoLauncher.configLogoLauncher() }
        else {
            fetchCoursesFromServer()
            loadProgressFromCloudKit()
//            configCollectionView()
//            configDataSource()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) { logoLauncher = nil }
    
    
//    deinit { logoLauncher.removeAllAVPlayerLayers() }
    
    //-------------------------------------//
    // MARK: - CONFIGURATION
    
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
//        let courseCellRegistration = UICollectionView.CellRegistration<SNCourseCell, Course> { cell, indexPath, course in
//            
//            var contentConfiguration = UIListContentConfiguration.subtitleCell()
//            contentConfiguration.text = course.name
//            contentConfiguration.secondaryText = course.instructor
//            contentConfiguration.imageProperties.cornerRadius = 4
//            contentConfiguration.imageProperties.maximumSize = CGSize(width: 60, height: 60)
//            contentConfiguration.image = {
//                let url = URL(string: course.avatarUrl)
//                if let data = try? Data(contentsOf: url!) {
//                    let image: UIImage = UIImage(data: data)!
//                    return image
//                }
//            }()
//            
//            cell.contentConfiguration = contentConfiguration
//            
//            if course.isBookmarked {
//                // put bookmark accessory on it
//            }
//        }
//        
        courseListDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [self] collectionView, indexPath, identifier -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SNCourseCell.reuseID, for: indexPath) as! SNCourseCell
            let course = courses.first { $0.id == identifier }!
            cell.set(course: course)
            
            return cell
        }
    }
    
    /**
     private func configDataSource()
     {
         courseListDataSource = UICollectionViewDiffableDataSource<Section, Course>(collectionView: collectionView) { (collectionView, indexPath, course) -> UICollectionViewCell? in
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SNCourseCell.reuseID, for: indexPath) as! SNCourseCell
             
             return cell
         }
     }
     */
    
    
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
        let testProject1 = CourseProject(id: 1, name: "proj1", subtitle: "sub1", skills: "swift", link: "www.com", index: 1, completed: false)
        let testProject2 = CourseProject(id: 2, name: "proj2", subtitle: "sub1z", skills: "swiftz", link: "www.comz", index: 1, completed: false)
        let testProject3 = CourseProject(id: 3, name: "proj2", subtitle: "sub1z", skills: "swiftz", link: "www.comz", index: 1, completed: false)
        
        let testCourse = Course(id: 1, name: "new course", instructor: "james brown", bio: "sing it today", isBookmarked: true, avatarUrl: "https://www.pinclipart.com/downpngs/ibiiRoi_dummy-profile-image-url-clipart/", courseProjects: [testProject1] )
        let testCourse2 = Course(id: 2, name: "new coursez", instructor: "james brownz", bio: "sing it todayz", isBookmarked: false, avatarUrl: "https://www.pinclipart.com/downpngs/ibiiRoi_dummy-profile-image-url-clipart/", courseProjects: [testProject2] )
        let testCourse3 = Course(id: 3, name: "new coursez", instructor: "james brownz", bio: "sing it todayz", isBookmarked: false, avatarUrl: "https://www.pinclipart.com/downpngs/ibiiRoi_dummy-profile-image-url-clipart/", courseProjects: [testProject3] )
        let testCourse4 = Course(id: 4, name: "new coursez", instructor: "james brownz", bio: "sing it todayz", isBookmarked: false, avatarUrl: "https://www.pinclipart.com/downpngs/ibiiRoi_dummy-profile-image-url-clipart/", courseProjects: [testProject3] )
        courses.append(testCourse)
        courses.append(testCourse2)
        courses.append(testCourse3)
        courses.append(testCourse4)
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, Course.ID>()
        snapshot.appendSections([.main])
        let courseIDs = courses.map { $0.id }
        #warning("problem child: see docs > Updating collection views using diffable data sources")
        snapshot.appendItems(courseIDs)
//        snapshot.appendItems(courses)
        
        DispatchQueue.main.async { self.courseListDataSource.apply(snapshot, animatingDifferences: true) }
    }
}



