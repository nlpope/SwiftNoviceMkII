//  File: PersistenceManager.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit

//enum BookmarkToggleActionType
//{
//    case add, remove
//}
//
//enum CompletionToggleActionType
//{
//    case complete, incomplete
//}

enum PersistenceManager
{
    static private let defaults = UserDefaults.standard
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH VC VISIT STATUS
    
    static func saveHomeCoursesVCVisitStatus(status: PersistenceKeys.VCVisitStatusType)
    {
        
    }
    
    
    static func saveCourseProjectsVCVisitStatus(status: PersistenceKeys.VCVisitStatusType)
    {
        
    }
    
    
    static func fetchHomeCoursesVCVisitStatus() -> PersistenceKeys.VCVisitStatusType
    {
        
    }
    
    
    static func fetchHomeCoursesVCVisitStatus() -> PersistenceKeys.VCVisitStatusType
    {
        
    }
    
    
    static func saveVCVisitStatus(for vc: UIViewController, status: PersistenceKeys.VCVisitStatusType)
    {
        switch vc {
        case is HomeCoursesVC:
            print("saving home vc visit status")
            do {
                let encoder = JSONEncoder()
                let encodedStatus = try encoder.encode(status)
                defaults.set(encodedStatus, forKey: PersistenceKeys.VCVisitStatusType.homeVCVisitStatusKey)
            } catch {
                print("failed to save home courses vc visit status")
            }
            
        /**--------------------------------------------------------------------------**/

        case is CourseProjectsVC:
            print("saving projects vc visit status")
            do {
                let encoder = JSONEncoder()
                let encodedStatus = try encoder.encode(status)
                defaults.set(encodedStatus, forKey: PersistenceKeys.VCVisitStatusType.projectsVCVisitStatusKey)
            } catch {
                print("failed to save course projects vc vist status")
            }
            
        /**--------------------------------------------------------------------------**/

        default:
            break
        }
    }
    
    
    static func fetchVCVisitStatus(for vc: UIViewController) -> PersistenceKeys.VCVisitStatusType
    {
        switch vc {
        case is HomeCoursesVC:
            guard let encodedStatus = defaults.object(forKey: PersistenceKeys.VCVisitStatusType.homeVCVisitStatusKey) as? Data
            else { return .isFirstVisit }
            
            do {
                let decoder = JSONDecoder()
                let fetchedStatus = try decoder.decode(PersistenceKeys.VCVisitStatusType.self, from: encodedStatus)
                return fetchedStatus
            } catch {
                print("failed to load home courses vc visit status")
                return .isFirstVisit
            }
            
        /**--------------------------------------------------------------------------**/

        case is CourseProjectsVC:
            guard let vcVisitStatusData = defaults.object(forKey: PersistenceKeys.VCVisitStatusType.projectsVCVisitStatusKey) as? Data
            else { return .isFirstVisit }
            
            do {
                let decoder = JSONDecoder()
                let fetchedStatus = try decoder.decode(PersistenceKeys.VCVisitStatusType.self, from: vcVisitStatusData)
                return fetchedStatus
            } catch {
                print("failed to load course projects vc visit status")
                return .isFirstVisit
            }
            
        /**--------------------------------------------------------------------------**/

        default:
            break
        }
        
        return .isFirstVisit
    }
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH COURSE BOOKMARKS & PROGRESS
    
    static func saveCoursesProgress(with course: Course, actionType: PersistenceKeys.CourseProgressType, completed: @escaping (SNError?) -> Void)
    {
        fetchProgress(forCourse: course) {
            
        }
        
        PersistenceKeys.CourseProgressType.courseProgressKey
        PersistenceKeys.CourseProgressType.courseProjectsProgressKey
        
        
        // course projects = track """"""", but course just has the api link
        // after you fetch, say if !bookmarkedCourseProjects.isEmpty, selectedCourse.isBookmarked = true 
        
    }
    
    
    static func saveProjectsProgress(with project: CourseProject, actionType: PersistenceKeys.CourseProgressType
    
    // JUST MAKE THE COURSES PAGE ON THE FLY AS THE PROJECTS PROGRESS GETS LOADED IN, THEN PERSIST THAT (COURSES) IN THE EXPECTED KEY
    static func fetchCoursesProgress(completed: @escaping (Result<[Course], SNError>) -> Void) -> Void
    {
        guard let courseProgressData = defaults.object(forKey: PersistenceKeys.CourseProgressType.courseProgressKey) as? Data
        else { completed(.success([])); return }
        
        do {
            let decoder = JSONDecoder()
            let decodedProgress = try decoder.decode(Course.self, from: courseProgressData)
            completed(.success([decodedProgress]))
        } catch {
            
        }
    }
    
    
    static func fetchProjectsProgress(forCourseProjec)
    
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

