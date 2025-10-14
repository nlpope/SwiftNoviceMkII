//  File: CourseProjectsVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 8/4/25.

import UIKit
import SafariServices
import CoreSpotlight
import MobileCoreServices

// ADD ALERTS ON 1ST VIEW || 'NAVIGATION INSTRUCTIONS' BUTTON:
// #1 "WELCOME TO THE COURSE PROJECTS PAGE. YOU CAN CLICK A PROJECT TO FOLLOW ITS LINK, OR GO INTO EDIT MODE TO ADD A BOOKMARK OR MARK IT AS COMPLETE."
// #2 "WHEN ALL PROJECTS ARE COMPLETE THIS COURSE WILL BE MARKED COMPLETE AS WELL."
// #3 "WE'VE DONE OUR BEST TO KEEP EVERYTHING UP TO DATE, BUT IF YOU NOTICE A DISCREPANCY PLEASE FEEL FREE TO REACH OUT"

class CourseProjectsVC: SNDataLoadingVC, SNTableViewDiffableDataSourceDelegate
{
    // split sections up based on if selectedCourse == playgrounds 1 or 2
    // thru here i can say selectedCourse.iscompleted/bookmarked = true or false
    var selectedCourse: Course!
    var delegate: HomeCoursesVC!
    var editModeOn: Bool = false
    var courseProjects = [CourseProject]()
    var tableView: UITableView!
    var dataSource: SNTableViewDiffableDataSource!
    
    
    init(selectedCourse: Course, delegate: HomeCoursesVC)
    {
        super.init(nibName: nil, bundle: nil)
        self.selectedCourse = selectedCourse
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
        // animate 'go to selectedCourse' button to pop in
        // if first time visiting - show alerts for nav instructions
        // fetchCourseProjects(withUrl url: String)
        // { url = selectedCourse.apiUrl }
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //-------------------------------------//
    // MARK: - CONFIGURATION
    
    func configNavBar()
    {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let followCourseButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(goToCourseTapped))
        
        navigationItem.rightBarButtonItems = [addButton, followCourseButton]
    }
    
    
    func configSearchController()
    {
        
    }
    
    
    func configDiffableDataSource()
    {
        dataSource = SNTableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, project in
            let cell = tableView.dequeueReusableCell(withIdentifier: "SSCell", for: indexPath)
            
            let cellTitle = project.title == "" ? "Untitled" : "Project \(project.index) \(project.title)"
            let cellSubtitle = project.subtitle == "" ? "" : project.subtitle
            let cellSkillList = project.skills == "" ? "" : project.skills
            
            // contin. @ tableView delegate sect > tableView(_:editingStyleForRowAt:)
            if self.favorites.contains(project) {
                cell.editingAccessoryType = .checkmark
                cell.accessoryType = .checkmark
            } else {
                cell.editingAccessoryType = .none
                cell.accessoryType = .none
            }
            
            cell.textLabel?.attributedText = self.makeAttributedString(title: cellTitle, subtitle: cellSubtitle, skills: cellSkillList)
            
            return cell
        }
    }
    
    
    func configTableView()
    {
        tableView = UITableView(frame: view.bounds)
        
        view.addSubview(tableView)
        //        tableView.delegate          = self
        tableView.backgroundColor   = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    @objc func addButtonTapped()
    {
        print("added to bookmarks - not really")
    }
    
    
    @objc func goToCourseTapped()
    {
        print("follow selectedCourse tapped")
        print("course url: \(selectedCourse.courseUrl)")
    }
    
    
    func updateBookmarksBin(with project: CourseProject, actionType: ProjectBookmarkToggleActionType)
    {
        switch actionType {
        case .add:
            print("add tapped")
        case .remove:
            print("remove tapped")
        }
    }
    
    
    func updateCompletedBin(with project: CourseProject, actionType: ProjectCompletionToggleActionType)
    {
        switch actionType {
        case .complete:
            completedProjects.append(project)
            PersistenceManager.updateCompletedBin(with: project, actionType: .complete ) { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
                    presentSNAlertOnMainThread(alertTitle: <#T##String#>, message: <#T##String#>, buttonTitle: <#T##String#>)
                    presentSNAlertOnMainThread(title: AlertKeys.saveSuccessTitle, msg: AlertKeys.saveSuccessMsg, btnTitle: "Ok")
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
    
    //-------------------------------------//
    // MARK: - ATTRIBUTED STRING CREATION
    
    func makeAttributedString(title: String, subtitle: String, skills: String) -> NSAttributedString
    {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
        let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        let skillsAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline), NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: "\(subtitle)\n", attributes: subtitleAttributes)
        let skillsString = NSAttributedString(string: skills, attributes: skillsAttributes)
        
        titleString.append(subtitleString)
        titleString.append(skillsString)
        return titleString
    }
    
    //-------------------------------------//
    // MARK: - EDIT MODE TOGGLER
    
    @objc func toggleEditMode() { editModeOn.toggle() }
    
    //-------------------------------------//
    // MARK: - COURSE PROGRESS PERSISTENCE
    
    func updateCoursesProgress(with: Course)
    {
        // delegate = HomeCoursesVC w [Course] I can dig into and save/load
        // so... delegate.
        
    }
    
    //-------------------------------------//
    // MARK: - TABLEVIEW DELEGATE METHODS 1/2 (SEE SNTableViewDiffableDataSource)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let activeArray = isSearching ? filteredProjects : projects
        tableView.deselectRow(at: indexPath, animated: true)
        showTutorial(activeArray[indexPath.row].index)
    }
    
    
    // contin.'d from configDiffableDataSource > cell.editingAccessoryType
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        let currentProject = projects[indexPath.row]
        if favorites.contains(currentProject) { return .delete }
        else { return .insert }
    }
}
