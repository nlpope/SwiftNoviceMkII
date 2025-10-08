//  File: CourseProjectsVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 8/4/25.

import UIKit
import SafariServices
import CoreSpotlight
import MobileCoreServices

class CourseProjectsVC: SNDataLoadingVC, SNTableViewDiffableDataSourceDelegate
{    
    var course: Course!
    var delegate: SNDataLoadingVC!
    var dataSource: SNTableViewDiffableDataSource!
    var courseProjects = [CourseProject]()
    var completedProjects = [CourseProject]()
    
    init(course: Course, delegate: SNDataLoadingVC)
    {
        super.init(nibName: nil, bundle: nil)
        self.course = course
        self.delegate = delegate
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        configNavBar()
        configSearchController()
        configDiffableDataSource()
        configTableView()
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        // animate 'go to course' button to pop in
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //-------------------------------------//
    // MARK: - CONFIGURATION
    
    func configNavBar()
    {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let followCourseButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(followCourseTapped))
        
        navigationItem.rightBarButtonItems = [addButton, followCourseButton]
    }
    
    
    func configSearchController()
    {
        
    }
    
    
    func configDiffableDataSource()
    {
        
    }
    
    
    func configTableView()
    {
        
    }
    
    
    @objc func addButtonTapped()
    {
        print("added to bookmarks - not really")
    }
    
    
    @objc func followCourseTapped()
    {
        print("follow course tapped")
    }
    
    
    func updateCompletedBin(with project: CourseProject, actionType: ProjectPersistenceActionType)
    {
        switch actionType {
        case .complete:
            completedProjects.append(project)
            PersistenceManager.updateFavorites(with: project, actionType: .complete) { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
                    presentSSAlertOnMainThread(title: AlertKeys.saveSuccessTitle, msg: AlertKeys.saveSuccessMsg, btnTitle: "Ok")
                    updateDataSource(with: projects)
                    return
                }
                self.presentSSAlertOnMainThread(title: "Failed to favorite", msg: error.rawValue, btnTitle: "Ok")
            }
            
        case .incomplete:
            favorites.removeAll { $0.title == project.title }
            PersistenceManager.updateFavorites(with: project, actionType: .remove) { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
                    presentSSAlertOnMainThread(title: AlertKeys.removeSuccessTitle, msg: AlertKeys.removeSuccessMsg, btnTitle: "Ok")
                    updateDataSource(with: projects)
                    return
                }
                self.presentSSAlertOnMainThread(title: "Failed to remove favorite", msg: error.rawValue, btnTitle: "Ok")
            }
        case .addToBookmarks:
            print("adding to bookmarks")
        case .deleteFromBookmarks:
            print("removing from bookmarks")
        }
    }
    
    
    
    
    /**
     incorporate following from ghfollowers: follwerlistvc
     
     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
         let offsetY         = scrollView.contentOffset.y
         let contentHeight   = scrollView.contentSize.height
         let height          = scrollView.frame.size.height
         
         if offsetY > contentHeight - height {
             guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
             page += 1
             getFollowers(username: username, page: page)
         }
     }
     
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         // pass login onto userinfoVC
         // present userinfoVC
         let activeArray     = isSearching ? filteredFollowers : followers
         let follower        = activeArray[indexPath.item]
         
         let destVC          = UserInfoVC()
         destVC.username     = follower.login
         destVC.delegate     = self
         
         let navController   = UINavigationController(rootViewController: destVC)
         present(navController, animated: true)
     }
     */

//    enum Section { case main }
//
//    class HudsonProjectsVC: SNDataLoadingVC, UISearchBarDelegate, UISearchResultsUpdating
//    {
//        var dataSource: SSTableViewDiffableDataSource!
//        var projects = [SSProject]()
//        var filteredProjects = [SSProject]()
//        var isSearching = false
//        var favorites = [SSProject]()
//        var editModeOn = false {
//            didSet { tableView.isEditing = editModeOn ? true : false; configNavigation() }
//        }
//        
//        var logoLauncher: SSLogoLauncher!
//        
//        
//        override func viewDidLoad()
//        {
//            super.viewDidLoad()
//            PersistenceManager.isFirstVisitStatus = true
//            configNavigation()
//            configSearchController()
//            configDiffableDataSource()
//            configTableView()
//        }
//        
//        
//        override func viewWillAppear(_ animated: Bool)
//        {
//            logoLauncher = SSLogoLauncher(targetVC: self)
//            editModeOn = false
//            if PersistenceManager.fetchFirstVisitStatus() { logoLauncher.configLogoLauncher() }
//            else { fetchProjects(); fetchFavorites() }
//        }
//        
//        
//        override func viewWillDisappear(_ animated: Bool) { logoLauncher = nil }
//        
//        
//        deinit { logoLauncher.removeAllAVPlayerLayers(); logoLauncher.removeNotifications() }
//        
//        //-------------------------------------//
//        // MARK: - CONFIGURATION
//        
//        func configNavigation()
//        {
//            view.backgroundColor = .systemBackground
//            title = "Projects"
//            navigationController?.navigationBar.prefersLargeTitles = true
//            
//            let editItem = UIBarButtonItem(barButtonSystemItem: editModeOn ? .done : .edit, target: self, action: #selector(toggleEditMode))
//            
//            navigationItem.rightBarButtonItem = editItem
//        }
//        
//        
//        func configSearchController()
//        {
//            let mySearchController = UISearchController()
//            mySearchController.searchResultsUpdater = self
//            mySearchController.searchBar.delegate = self
//            mySearchController.searchBar.placeholder = "Search projects"
//            mySearchController.obscuresBackgroundDuringPresentation = false
//            
//            navigationItem.searchController = mySearchController
//            navigationItem.hidesSearchBarWhenScrolling = false
//        }
//        
//        
//        func configTableView()
//        {
//            tableView.allowsSelectionDuringEditing = false
//            dataSource.delegate = self
//        }
//        
//
//        func configDiffableDataSource()
//        {
//            dataSource = SSTableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, project in
//                let cell = tableView.dequeueReusableCell(withIdentifier: "SSCell", for: indexPath)
//                
//                let cellTitle = project.title == "" ? "Untitled" : "Project \(project.index) \(project.title)"
//                let cellSubtitle = project.subtitle == "" ? "" : project.subtitle
//                let cellSkillList = project.skills == "" ? "" : project.skills
//                            
//                // contin. @ tableView delegate sect > tableView(_:editingStyleForRowAt:)
//                if self.favorites.contains(project) {
//                    cell.editingAccessoryType = .checkmark
//                    cell.accessoryType = .checkmark
//                } else {
//                    cell.editingAccessoryType = .none
//                    cell.accessoryType = .none
//                }
//                
//                cell.textLabel?.attributedText = self.makeAttributedString(title: cellTitle, subtitle: cellSubtitle, skills: cellSkillList)
//                
//                return cell
//            }
//        }
//        
//        //-------------------------------------//
//        // MARK: - ATTRIBUTED STRING CREATION
//        
//        func makeAttributedString(title: String, subtitle: String, skills: String) -> NSAttributedString
//        {
//            let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
//            let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
//            let skillsAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline), NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
//            
//            let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
//            let subtitleString = NSAttributedString(string: "\(subtitle)\n", attributes: subtitleAttributes)
//            let skillsString = NSAttributedString(string: skills, attributes: skillsAttributes)
//            
//            titleString.append(subtitleString)
//            titleString.append(skillsString)
//            return titleString
//        }
//        
//        //-------------------------------------//
//        // MARK: - FETCHING (NETWORK & PERSISTENCE MANAGER CALLS)
//        
//        func fetchProjects()
//        {
//            showLoadingView()
//            NetworkManager.shared.fetchProjects { [weak self] result in
//                guard let self = self else { return }
//                self.dismissLoadingView()
//                
//                switch result {
//                case .success(let projects):
//                    self.projects = projects; self.updateDataSource(with: projects)
//                /**--------------------------------------------------------------------------**/
//                case .failure(let error):
//                    self.presentSSAlertOnMainThread(title: "Fetch Fail", msg: error.rawValue, btnTitle: "Ok")
//                }
//            }
//        }
//        
//        
//        func fetchFavorites()
//        {
//            PersistenceManager.fetchFavorites { result in
//                switch result {
//                case .success(let savedFavorites):
//                    self.favorites = savedFavorites
//                case .failure(let error):
//                    self.presentSSAlertOnMainThread(title: "Failed to load favorites", msg: error.rawValue, btnTitle: "Ok")
//                }
//            }
//        }
//        
//        //-------------------------------------//
//        // MARK: - SEARCH CONTROLLER METHODS
//        
//        func updateSearchResults(for searchController: UISearchController)
//        {
//            guard let desiredFilter = searchController.searchBar.text, !desiredFilter.isEmpty
//            else { return }
//            isSearching = true
//            filteredProjects = projects.filter {
//                $0.title.lowercased().contains(desiredFilter.lowercased())
//                || $0.subtitle.lowercased().contains(desiredFilter.lowercased())
//                || $0.skills.lowercased().contains(desiredFilter.lowercased())
//                || $0.index.description.contains(desiredFilter)
//            }
//            updateDataSource(with: filteredProjects)
//        }
//        
//        
//        func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
//        { searchBar.resignFirstResponder(); isSearching = false; updateDataSource(with: projects) }
//        
//        
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
//        {
//            if searchText == "" { isSearching = false; updateDataSource(with: projects) }
//            else { isSearching = true }
//        }
//        
//        //-------------------------------------//
//        // MARK: - EDIT MODE (ADD/REMOVE FAVORITES)
//        
//        @objc func toggleEditMode() { editModeOn.toggle() }
//        
//        
//        func updateFavorites(with project: SSProject, actionType: PersistenceActionType)
//        {
//            switch actionType {
//            case .add:
//                favorites.append(project)
//                PersistenceManager.updateFavorites(with: project, actionType: .add) { [weak self] error in
//                    guard let self = self else { return }
//                    guard let error = error else {
//                        presentSSAlertOnMainThread(title: AlertKeys.saveSuccessTitle, msg: AlertKeys.saveSuccessMsg, btnTitle: "Ok")
//                        updateDataSource(with: projects)
//                        return
//                    }
//                    self.presentSSAlertOnMainThread(title: "Failed to favorite", msg: error.rawValue, btnTitle: "Ok")
//                }
//                
//            case .remove:
//                favorites.removeAll { $0.title == project.title }
//                PersistenceManager.updateFavorites(with: project, actionType: .remove) { [weak self] error in
//                    guard let self = self else { return }
//                    guard let error = error else {
//                        presentSSAlertOnMainThread(title: AlertKeys.removeSuccessTitle, msg: AlertKeys.removeSuccessMsg, btnTitle: "Ok")
//                        updateDataSource(with: projects)
//                        return
//                    }
//                    self.presentSSAlertOnMainThread(title: "Failed to remove favorite", msg: error.rawValue, btnTitle: "Ok")
//                }
//            }
//        }
//        
//        //-------------------------------------//
//        // MARK: - TABLEVIEW DELEGATE METHODS 1/2
//        
//        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//        {
//            let activeArray = isSearching ? filteredProjects : projects
//            tableView.deselectRow(at: indexPath, animated: true)
//            showTutorial(activeArray[indexPath.row].index)
//        }
//        
//
//        // contin.'d from configDiffableDataSource > cell.editingAccessoryType
//        override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
//        {
//            let currentProject = projects[indexPath.row]
//            if favorites.contains(currentProject) { return .delete }
//            else { return .insert }
//        }
//        
//        //-------------------------------------//
//        // MARK: - DIFFABLE DATASOURCE UPDATES
//        
//        func updateDataSource(with projects: [SSProject])
//        {
//            var snapshot = NSDiffableDataSourceSnapshot<Section, SSProject>()
//            snapshot.appendSections([.main])
//            snapshot.appendItems(projects)
//            
//            DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
//        }
//        
//        //-------------------------------------//
//        // MARK: - SAFARI PRESENTATION METHODS
//        
//        @objc func showTutorial(_ which: Int)
//        {
//            print("show tutorial accessed")
//            if let url = URL(string: "\(URLKeys.baseURL)\(which)") {
//                let config = SFSafariViewController.Configuration()
//                config.entersReaderIfAvailable = true
//                
//                let vc = SFSafariViewController(url: url, configuration: config)
//                present(vc, animated: true)
//            }
//        }
//    }

}
