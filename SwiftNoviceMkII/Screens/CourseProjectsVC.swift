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

class CourseProjectsVC: SNDataLoadingVC, UITableViewDataSource, UITableViewDelegate
{
    // split sections up based on if selectedCourse == playgrounds 1 or 2
    // thru here i can say selectedCourse.iscompleted/bookmarked = true or false
    var vcVisitStatus: PersistenceKeys.VCVisitStatusType! {
        didSet { PersistenceManager.saveVCVisitStatus(for: self, status: vcVisitStatus) }
    }
    
    var selectedCourse: Course!
    var editModeOn: Bool = false
    var projects = [CourseProject]()
    var filteredProjects = [CourseProject]()
    
    var isSearching = false
    var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Section, CourseProject.ID>!
//    var dataSource: SNTableViewDiffableDataSource!
    
    
    init(selectedCourse: Course)
    {
        super.init(nibName: nil, bundle: nil)
        self.selectedCourse = selectedCourse
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        configNavBar()
        configSearchController()
        configDiffableDataSource()
        configTableView()
        vcVisitStatus = PersistenceManager.fetchVCVisitStatus(for: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        configKeyboardBehavior()
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        // animate 'go to selectedCourse' button to pop in
        // if first time visiting - show alerts for nav instructions
        // fetchCourseProjects(withUrl url: String)
        // { url = selectedCourse.apiUrl }
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        view.gestureRecognizers?.removeAll()
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
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, project in
            let cell = tableView.dequeueReusableCell(withIdentifier: SNCourseProjectCell.reuseID, for: indexPath)
            
            let cellTitle = project.title == "" ? "Untitled" : "\(project.title)"
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
    
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH COURSE BOOKMARKS & PROGRESS
    
    
    
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
    // MARK: - NETWORK & PERSISTENCE MANAGER CALLS
    
    func fetchCourseProjects()
    {
        
    }
    
    
    func updateCourseProgress(withProject project: inout CourseProject, actionType: PersistenceKeys.ProgressType)
    {
        PersistenceManager.updateProgress(with: project, actionType: actionType) { error in
            //
        }
    }
    
    //-------------------------------------//
    // MARK: - TABLEVIEW DELEGATE METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        let sectionNumber = selectedCourse.name.contains("Swift Playgrounds") ? 2 : 1
        return sectionNumber
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // if selectedCourse = Swift Playgrounds ...
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // if fetched CourseProject.isBookmarked ...
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let activeArray = isSearching ? filteredProjects : projects
        tableView.deselectRow(at: indexPath, animated: true)
        followProjectLink(at: activeArray[indexPath.row].projectUrl!)
    }
    
    //-------------------------------------//
    // MARK: - SAFARI PRESENTATION METHODS
    
    @objc func followProjectLink(at link: String)
    {
        if let url = URL(string: link) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}
