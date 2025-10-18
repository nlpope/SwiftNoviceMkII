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

protocol CourseItem
{
    var isBookmarked: Bool { get set }
    var isCompleted: Bool { get set }
}

enum PersistenceManager
{
    static private let defaults = UserDefaults.standard
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH VC VISIT STATUS
    
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
    // MARK: - SAVE / FETCH BOOKMARKS & PROGRESS
    
   
    static func updateProgress<T>(with item: T, actionType: PersistenceKeys.ProgressType, completed: @escaping (SNError) -> Void) -> Void
    where T: Codable, T: Identifiable
    {
        fetchProgress(forType: type(of: item)) { result in
            switch result {
            case .success(let progress):
                
            /**--------------------------------------------------------------------------**/
            case.failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func handle<T>(_ actionType: PersistenceKeys.ProgressType, for item: inout T, in array: inout [T], completed: @escaping (SNError?) -> Void)
    where T: Codable, T: Identifiable, T: CourseItem
    {
        switch actionType {
        case .addBookmark:
            array.removeAll { $0.id == item.id }
            item.isBookmarked = true
            array.append(item)
        /**--------------------------------------------------------------------------**/
        case .removeBookmark:
            array.removeAll { $0.id == item.id }
            item.isBookmarked = false
            array.append(item)
        /**--------------------------------------------------------------------------**/
        case .markComplete:
            array.removeAll { $0.id == item.id }
            item.isCompleted = true
            array .append(item)
        /**--------------------------------------------------------------------------**/
        case .markIncomplete:
            array.removeAll { $0.id == item.id }
            item.isCompleted = false
            array.append(item)
        }
    }
    
    
    static func fetchProgress<T>(forType fetchType: T.Type, completed: @escaping (Result<[T], SNError>) -> Void) -> Void
    where T: Codable, T: Identifiable
    {
        var key: String!
        
        switch fetchType {
        //so not literally Course, but the type Course - this is how this is captured in signatures
        case is Course.Type:
            key = PersistenceKeys.ProgressType.coursesProgressKey
        case is CourseProject.Type:
            key = PersistenceKeys.ProgressType.coursesProgressKey
        default:
            break
        }
        
        guard let progressData = defaults.object(forKey: key) as? Data
        else { completed(.success([])); return }
        
        do {
            let decoder = JSONDecoder()
            let decodedProgress = try decoder.decode([T].self, from: progressData)
            completed(.success(decodedProgress))
        } catch {
            completed(.failure(.failedToLoadProgress))
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

