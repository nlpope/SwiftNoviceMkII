//  File: HomeCoursesVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit
import SafariServices
import CoreSpotlight
import MobileCoreServices


class HomeCoursesVC: SNDataLoadingVC, UISearchBarDelegate, UISearchResultsUpdating, UICollectionViewDelegate
{
    var courses = [Course]()
    var filteredCourses = [Course]()
    var completedCourses = [Course]()
    var isSearching = false
    var logoLauncher: SNLogoLauncher!
    var vcVisitStatus: PersistenceKeys.VCVisitStatusType = .isFirstVisit {
        didSet { PersistenceManager.saveVCVisitStatus(for: self, status: vcVisitStatus) }
    }
    
    var collectionView: UICollectionView!
    private var courseListDataSource: UICollectionViewDiffableDataSource<Section, Course.ID>!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        vcVisitStatus = PersistenceManager.fetchVCVisitStatus(for: self)
        configNavBar()
        configSearchController()
        configCollectionView()
        configDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        if PersistenceManager.fetchFirstVisitToCoursesPostDismissalStatus() {
            logoLauncher = SNLogoLauncher(targetVC: self)
            logoLauncher.configLogoLauncher()
        }
        else {
            loadProgressFromCloudKit()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) { logoLauncher = nil }
    
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
            var targetCourse: Course?
            for course in courses {
                if course.id == identifier { targetCourse = course}
            }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SNCourseCell.reuseID,
                                                          for: indexPath) as! SNCourseCell
            
            if targetCourse != nil { cell.set(course: targetCourse!) }
            
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
    
    
//    func hideSearchController()
//    { navigationItem.searchController?.searchBar.isHidden = true }
    
    //-------------------------------------//
    // MARK: - FETCHING
    
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
        guard !courses.isEmpty else {
            let message = "Issue loading courses"
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }; return
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
        
        let destVC = CourseProjectsVC(selectedCourse: selectedCourse, delegate: self)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
}
