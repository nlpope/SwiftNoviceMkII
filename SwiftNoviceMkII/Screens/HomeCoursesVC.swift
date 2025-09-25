//  File: HomeCoursesVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit

struct DataStore
{
    func findCourse(in courses: [Course], with identifier: UUID?) -> Course?
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
//            fetchCoursesFromServer()
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
            if course != nil { cell.set(course: course!) }
            
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
    
    
    func hideSearchController()
    { navigationItem.searchController?.searchBar.isHidden = true }
    
    
    func fetchCoursesFromServer()
    {
        showLoadingView()
        
        NetworkManager.shared.fetchCourses { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let courses):
                self.courses = courses
                print("just fetched, now courses.count = \(courses.count)")
                updateDataSource(with: courses)
            case .failure(let error):
                self.presentSNAlertOnMainThread(alertTitle: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func loadProgressFromCloudKit()
    {
        print("loading progress")
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
        if courses.isEmpty {
            let message = "Issue loading courses"
            DispatchQueue.main.async {
//                self.hideSearchController()
                self.showEmptyStateView(with: message, in: self.view)
            }
        }
        
        let courseIds = courses.map { $0.id }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Course.ID>()
        snapshot.appendSections([.main])
        
        snapshot.appendItems(courseIds, toSection: .main)
        DispatchQueue.main.async { self.courseListDataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    //-------------------------------------//
    // MARK: - COLLECTIONVIEW DELEGATE METHODS
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let activeArray = isSearching ? filteredCourses : courses
        let selectedCourse = activeArray[indexPath.item]
        
        let destVC = CourseProjectsVC(course: selectedCourse)
//        destVC.delegate = self
        
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}
