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

enum VCVisitStatusType: Codable
{
    case isFirstVisit, isFirstVisitPostDismissal
    static let homeVCVisitStatusKey = "homeVCVisitStatusKey"
    static let projectsVCVisitStatusKey = "projectsVCVisitStatusKey"
}

enum PersistenceManager
{
    static private let defaults = UserDefaults.standard
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH VC VISIT STATUS
    
    #warning("finished w fetch fun, now finish save func - officially refactored/condensed into 2 funcs instead of 6000")
    static func saveVCVisitStatus(for vc: UIViewController, status: VCVisitStatusType)
    {
        
    }
    
    
    static func fetchVCVisitStatus(for vc: UIViewController) -> VCVisitStatusType
    {
        switch vc {
        case is HomeCoursesVC:
            guard let vcVisitStatusData = defaults.object(forKey: VCVisitStatusType.homeVCVisitStatusKey) as? Data
            else { return .isFirstVisit }
            
            do {
                let decoder = JSONDecoder()
                let fetchedStatus = try decoder.decode(VCVisitStatusType.self, from: vcVisitStatusData)
                return fetchedStatus
            } catch {
                print("unable to load very first visit status")
                return .isFirstVisit
            }
            
        case is CourseProjectsVC:
            guard let vcVisitStatusData = defaults.object(forKey: VCVisitStatusType.projectsVCVisitStatusKey) as? Data
            else { return .isFirstVisit }
            
            do {
                let decoder = JSONDecoder()
                let fetchedStatus = try decoder.decode(VCVisitStatusType.self, from: vcVisitStatusData)
                return fetchedStatus
            } catch {
                print("unable to load very first visit status")
                return .isFirstVisit
            }
        default:
            break
        }
        
        return .isFirstVisit
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

