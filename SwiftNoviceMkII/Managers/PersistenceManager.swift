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
   
    static func updateProgress<T>(with item: T, actionType: PersistenceKeys.ProgressType, completed: @escaping (SNError?) -> Void) -> Void
    where T: Codable, T: Identifiable, T: CourseItem
    {
        fetchProgress(forType: type(of: item)) { result in
            switch result {
            case .success(var progressArray):
                handle(actionType, for: item, in: &progressArray) { error in
                    if error != nil { completed(error); return }
                }
            /**--------------------------------------------------------------------------**/
            case.failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func fetchProgress<T>(forType fetchType: T.Type, completed: @escaping (Result<[T], SNError>) -> Void) -> Void
    where T: Codable, T: Identifiable, T: CourseItem
    {
        var key: String!
        
        switch fetchType {
        case is Course.Type:
            key = PersistenceKeys.ProgressType.coursesProgressBinKey
        /**--------------------------------------------------------------------------**/
        case is CourseProject.Type:
            key = PersistenceKeys.ProgressType.projectsProgressBinKey
        /**--------------------------------------------------------------------------**/
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
    
    
    static func handle<T>(_ actionType: PersistenceKeys.ProgressType, for item: T, in array: inout [T], completed: @escaping (SNError?) -> Void)
    where T: Codable, T: Identifiable, T: CourseItem
    {
        switch actionType {
        case .addBookmark:
            var tmpItem = item
            array.removeAll { $0.id == item.id }
            tmpItem.isBookmarked = true
            array.append(tmpItem)
        /**--------------------------------------------------------------------------**/
        case .removeBookmark:
            var tmpItem = item
            array.removeAll { $0.id == item.id }
            tmpItem.isBookmarked = false
            array.append(tmpItem)
        /**--------------------------------------------------------------------------**/
        case .markComplete:
            var tmpItem = item
            array.removeAll { $0.id == item.id }
            tmpItem.isCompleted = true
            array .append(tmpItem)
        /**--------------------------------------------------------------------------**/
        case .markIncomplete:
            var tmpItem = item
            array.removeAll { $0.id == item.id }
            tmpItem.isCompleted = false
            array.append(tmpItem)
        }
    }
    
    //-------------------------------------//
    // MARK: - LOGIN PERSISTENCE
    
    static func updateLoggedInStatus(loggedIn: Bool)
    { defaults.set(loggedIn, forKey: PersistenceKeys.loginStatusKey) }
    
    
    static func retrieveLoggedInStatus() -> Bool
    { return defaults.bool(forKey: PersistenceKeys.loginStatusKey) }
    // defaults.bool(forKey:) auto returns false if key doesn't yet exist
}

