//  File: PersistenceManager.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import Foundation

// courses marked completed manually (HomeCoursesVC = CourseProjectsVCDelegate)
// rmember, you only need persistence w the indiv. projects
// the course being the projects pg's delegate communicates the rest (completion & bookmarks) - so add language in HomeCoursesVC & BookmarksVC's viewWillAppear that asks if course is bookmarked since all we have is an scripts api link and not an array of projects

enum ProjectBookmarkToggleActionType
{
    case add, remove
}

enum ProjectCompletionToggleActionType
{
    case complete, incomplete
}

enum PersistenceManager
{
    static private let defaults = UserDefaults.standard
    
    static var isVeryFirstVisit: Bool = fetchVeryFirstVisitStatus() {
        didSet { PersistenceManager.saveVeryFirstVisit(status: isVeryFirstVisit) }
    }
    
    static var isFirstVisitPostDismissal: Bool! = fetchFirstVisitPostDismissalStatus() {
        didSet { PersistenceManager.saveFirstVisitPostDismissal(status: isFirstVisitPostDismissal) }
    }
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH VERY FIRST VISIT STATUS
    
    static func saveVeryFirstVisit(status: Bool)
    {
        do {
            let encoder = JSONEncoder()
            let encodedStatus = try encoder.encode(status)
            defaults.set(encodedStatus, forKey: PersistenceKeys.isVeryFirstVisitStatus)
        } catch {
            print("failed ato save very first visit status")
        }
    }
    
    
    static func fetchVeryFirstVisitStatus() -> Bool
    {
        guard let visitStatusData = defaults.object(forKey: PersistenceKeys.isVeryFirstVisitStatus) as? Data
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
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH VISIT POST DISMISSAL STATUS (FOR LOGO LAUNCHER)
    
    static func saveFirstVisitPostDismissal(status: Bool)
    {
        do {
            let encoder = JSONEncoder()
            let encodedStatus = try encoder.encode(status)
            defaults.set(encodedStatus, forKey: PersistenceKeys.isFirstVisitPostDismissalStatus)
        } catch {
            print("failed ato save first visit post dismissal status")
        }
    }
    
    
    static func fetchFirstVisitPostDismissalStatus() -> Bool
    {
        guard let visitStatusData = defaults.object(forKey: PersistenceKeys.isFirstVisitPostDismissalStatus) as? Data
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
    // MARK: - COMPLETION PERSISTENCE
    
    static func updateCompletedProjectsBin(with project: CourseProject, actionType: ProjectPersistenceActionType, completed: @escaping (SNError?) -> Void)
    {
        fetchCourseProgress { result in
            switch result {
            case .success(var courses):
                handle(actionType, for: course, in: &courses) { error in
                    if error != nil { completed(error); return }
                }
                completed(saveAllProgress(for: courses))
            /**--------------------------------------------------------------------------**/
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    //-------------------------------------//
    // MARK: - BOOKMARK PERSISTENCE
    
    static func updateBookmarkedCoursesBin(with course: Course, actionType: ProjectBookmarkToggleActionType, completed: @escaping (SNError?) -> Void)
    {
        
    }
    
    
    static func updateBookmarkedProjectsBin(with project: CourseProject, actionType: ProjectBookmarkToggleActionType, completed: @escaping (SNError?) -> Void)
    {
        
    }
    
    //-------------------------------------//
    // MARK: - HELPER FUNCTION
    
    
    static func handleCompletion(_ actionType: ProjectCompletionToggleActionType, for course: Course, in courses:  inout [Course], completed: @escaping (SNError?) -> Void)
    {
        switch actionType {
        case .complete:
            courses.removeAll { $0.name == course.name }
            courses.append(course)
        /**--------------------------------------------------------------------------**/
        case .incomplete:
            courses.removeAll { $0.name == course.name }
        }
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
        
    
    static func fetchCourseProgress(completed: @escaping (Result<[Course], SNError>) -> Void)
    {
        guard let completedCoursesData = defaults.object(forKey: PersistenceKeys.completedCourses) as? Data else {
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

