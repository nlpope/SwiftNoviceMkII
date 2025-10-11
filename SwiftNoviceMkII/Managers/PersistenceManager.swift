//  File: PersistenceManager.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation
import UIKit

// courses marked completed manually (HomeCoursesVC = CourseProjectsVCDelegate)
// rmember, you only need persistence w the indiv. projects
// the course being the projects pg's delegate communicates the rest (completion & bookmarks) - so add language in HomeCoursesVC & BookmarksVC's viewWillAppear that asks if course is bookmarked since all we have is an scripts api link and not an array of projects

enum BookmarkToggleActionType
{
    case add, remove
}

enum CompletionToggleActionType
{
    case complete, incomplete
}

enum HomeCoursesKeys
{
    static let isFirstVisit = "isFirstVisit"
}

enum CourseProjectKeys
{
    static let isFirstVisit = "isFirstVisit"
}

enum PersistenceManager
{
    static private let defaults = UserDefaults.standard
    
   
    
//    static var isVeryFirstVisitToCourses: Bool = fetchVeryFirstVisitToCoursesStatus() {
//        didSet { PersistenceManager.saveVeryFirstVisitToCourses(status: isVeryFirstVisitToCourses) }
//    }
    
    static var isInitialVisitToVC: Bool = fetchVCVisitationStatus(forVC: HomeCoursesVC) {
//        didSet { PersistenceManager.saveVeryFirstVisitToCourses(status: isVeryFirstVisitToCourses) }
    }
    
//    static var isFirstVisitToCoursesPostDismissal: Bool! = fetchFirstVisitToCoursesPostDismissalStatus() {
//        didSet { PersistenceManager.saveFirstVisitToCoursesPostDismissal(status: isFirstVisitToHomePostDismissal) }
//    }
    
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH HOMECOURSESVC VISIT STATUS
    
    // MARK: - HOMECOURSESVC 1ST VISIT

    static func saveEntryStatus(forViewController vc: UIViewController, status: )
    {
        switch status {
        case .veryFirstVisit:
            do {
                let encoder = JSONEncoder()
                let encodedStatus = try encoder.encode(status)
                defaults.set(encodedStatus, forKey: PersistenceKeys.HomeCoursesVCEntryPostDismissalStatus)
            } catch {
                print("failed ato save first visit post dismissal status")
            }
        case .firstVisitPostDismissal:
            print("1st visit post dismissal")
        }
    }
    
    
    static func fetchVCVisitationStatus(forVC vc: UIViewController) -> Bool
    {
        switch vc {
        case is HomeCoursesVC:
            
            return true
        case is CourseProjectsVC:
            return true
        default:
            return false
        }
    }
    
    #warning("end new code - aim to delete the rest of the uncommented below this line")
    
    static func saveVeryFirstVisitToCourses(status: Bool)
    {
        do {
            let encoder = JSONEncoder()
            let encodedStatus = try encoder.encode(status)
            defaults.set(encodedStatus, forKey: PersistenceKeys.HomeCoursesVCInitialEntryStatus)
        } catch {
            print("failed ato save very first visit status")
        }
    }
    
    
    static func fetchVeryFirstVisitToCoursesStatus() -> Bool
    {
        guard let visitStatusData = defaults.object(forKey: PersistenceKeys.HomeCoursesVCInitialEntryStatus) as? Data
        else { return true }
        
        do {
            let decoder = JSONDecoder()
            let fetchedStatus = try decoder.decode(Bool.self, from: visitStatusData)
            return fetchedStatus
        } catch {
            print("unable to load very first visit status")
            return true
        }
    }
    
    // MARK: - HOMECOURSESVC 1ST VISIT POST DISMISSAL
    
    static func saveFirstVisitToCoursesPostDismissal(status: Bool)
    {
        do {
            let encoder = JSONEncoder()
            let encodedStatus = try encoder.encode(status)
            defaults.set(encodedStatus, forKey: PersistenceKeys.HomeCoursesVCEntryPostDismissalStatus)
        } catch {
            print("failed ato save first visit post dismissal status")
        }
    }
    
    
    static func fetchFirstVisitToCoursesPostDismissalStatus() -> Bool
    {
        guard let visitStatusData = defaults.object(forKey: PersistenceKeys.isFirstVisitToCourseProjectsPostDismissalStatus)
    }
        
    //-------------------------------------//
    // MARK: - SAVE / FETCH COURSEPROJECTSVC 1ST VISIT STATUS
    
    // MARK: - COURSEPROJECTSVC 1ST VISIT
    
    static func saveVeryFirstVisitToCourseProjects(status: Bool)
    {
        do {
            let encoder = JSONEncoder()
            let encodedStatus = try encoder.encode(status)
            defaults.set(encodedStatus, forKey: PersistenceKeys.isVeryFirstVisitToCourseProjectsStatus)
        } catch {
            print("failed ato save very first visit status")
        }
    }
    
    
    static func fetchVeryFirstVisitToCourseProjectsStatus() -> Bool
    {
        guard let visitStatusData = defaults.object(forKey: PersistenceKeys.isVeryFirstVisitToCourseProjectsStatus) as? Data
        else { return true }
        
        do {
            let decoder = JSONDecoder()
            let fetchedStatus = try decoder.decode(Bool.self, from: visitStatusData)
            return fetchedStatus
        } catch {
            print("unable to load very first visit status")
            return true
        }
    }
    
    // MARK: - COURSEPROJECTSVC 1ST VISIT POST DISMISSAL
    
    static func saveFirstVisitToCourseProjectsPostDismissal(status: Bool)
    {
        do {
            let encoder = JSONEncoder()
            let encodedStatus = try encoder.encode(status)
            defaults.set(encodedStatus, forKey: PersistenceKeys.isFirstVisitToCourseProjectsPostDismissalStatus)
        } catch {
            print("failed to save first visit post dismissal status")
        }
    }
    
    
    static func fetchFirstVisitToCourseProjectsPostDismissalStatus() -> Bool
    {
        guard let visitStatusData = defaults.object(forKey: PersistenceKeys.isFirstVisitToCourseProjectsPostDismissalStatus) as? Data
        else { return true }
        
        do {
            let decoder = JSONDecoder()
            let fetchedStatus = try decoder.decode(Bool.self, from: visitStatusData)
            return fetchedStatus
        } catch {
            print("unable to load first visit post dismissal status")
            return true
        }
    }
    
    //-------------------------------------//
    // MARK: - BOOKMARK & COMPLETION SAVING & FETCHING (with helper func)
    
//    static func updateCompletedBin(with project: CourseProject, actionType: ProjectCompletionToggleActionType, completed: @escaping (SNError?) -> Void)
//    {
//        fetchCourseProgress { result in
//            switch result {
//            case .success(var courses):
//                handle(actionType, for: course, in: &courses) { error in
//                    if error != nil { completed(error); return }
//                }
//                completed(saveAllProgress(for: courses))
//            /**--------------------------------------------------------------------------**/
//            case .failure(let error):
//                completed(error)
//            }
//        }
//    }
    
    
    static func updateCoursesProgress(with course: Course)
    {
        
    }
    
    
    static func updateCourseProjectsProgress(with courseProject: CourseProject)
    {
        
    }
     
  //NEW CODE BELOW
    
    static func fetchCourseProgress(completed: @escaping (Result<[Course], SNError>) -> Void)
    {
        guard let courseData = defaults.object(forKey: PersistenceKeys.coursesProgress) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let completedCourses = try decoder.decode([Course].self, from: completedCoursesData)
            completed(.success(completedCourses))
        } catch {
            completed(.failure(.failedToLoadProgress))
        }
    }
    
    
    static func fetchCourseProjectProgress(completed: @escaping (Result<[CourseProject], SNError>) -> Void)
    {
        
    }
    
    
    static func handleBookmark(_ actionType: ProjectBookmarkToggleActionType, for course: Course, in courses:  inout [Course], completed: @escaping (SNError?) -> Void)
    {
        switch actionType {
        case .add:
            courses.removeAll { $0.name == course.name }
            courses.append(course)
        /**--------------------------------------------------------------------------**/
        case .remove:
            courses.removeAll { $0.name == course.name }
        }
    }
    
    
    // BOOKMARKS & COMPLETED STATUS (NOT EDITABLE BY USER)
    static func saveAllProgress(for courses: [Course]) -> SNError?
    {
        do {
            let encoder = JSONEncoder()
            let encodedCompletedCourses = try encoder.encode(courses)
            defaults.setValue(encodedCompletedCourses, forKey: PersistenceKeys.completedCourses)
            return nil
        } catch {
            return .failedToSaveProgress
        }
    }
    
    //-------------------------------------//
    // MARK: - LOGIN PERSISTENCE
    
    static func updateLoggedInStatus(loggedIn: Bool)
    {
        guard loggedIn else {
            defaults.set(false, forKey: PersistenceKeys.isLoggedIn)
            return
        }
        defaults.set(true, forKey: PersistenceKeys.isLoggedIn)
        return
    }
    
    
    static func retrieveLoggedInStatus() -> Bool
    {
        let loggedInStatus = defaults.bool(forKey: PersistenceKeys.isLoggedIn)
        guard loggedInStatus else { return false }
        return true
    }
}

