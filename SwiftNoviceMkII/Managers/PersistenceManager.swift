//  File: PersistenceManager.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit

//-------------------------------------//
// MARK: - KEYS AND PROTOCOL & TYPE DEFINITIONS

protocol CourseItem
{
    var isBookmarked: Bool { get set }
    var isCompleted: Bool { get set }
}

enum FetchType { case courses, projects }
    
enum ProgressType
{
    case addBookmark, removeBookmark, markComplete, markIncomplete
    static let coursesProgressBinKey = "coursesProgressBinKey"
    static let projectsProgressBinKey = "projectsProgressBinKey"

}

enum VCVisitStatusType: Codable
{
    case isFirstVisit, isNotFirstVisit
    static let homeVCVisitStatusKey = "homeVCVisitStatusKey"
    static let projectsVCVisitStatusKey = "projectsVCVisitStatusKey"
}

//-------------------------------------//
// MARK: - MAIN PERSISTENCE MANAGER

enum PersistenceManager
{
    static private let defaults = UserDefaults.standard
    
    static private var existingUsers: [User] = fetchExistingUsersOnThisDevice() { error in
        #warning("handle error")
    }
    
    static var logoDidFlickerThisSession: Bool = fetchLogoDidFlickerStatus() {
        didSet { saveLogoDidFlickerStatus(status: logoDidFlickerThisSession) }
    }
    
    //-------------------------------------//
    // MARK: - USER PERSISTENCE
    
    static func updateExistingUsersOnThisDevice(with user: User)
    {
        fetchProgress(forType: type(of: item)) { result in
            switch result {
            case .success(var progressArray):
                //see note 10.20 in app delegate
                handle(actionType, for: item, in: &progressArray) { error in
                    if error != nil { completed(error); return }
                }
            /**--------------------------------------------------------------------------**/
            case.failure(let error):
                completed(error)
            }
        }
    }
    
    static func fetchExistingUsersOnThisDevice(completed: @escaping (Result<[User], SNError>) -> Void) -> [User]
    {
        guard let usersToDecode = defaults.object(forKey: PersistenceKeys.existingUsersKey) as? Data
        else { completed(.success([])) }
        
        do {
            let decoder = JSONDecoder()
            let decodedUsers = decoder.decode([User].self, from: usersToDecode)
        } catch {
            
        }
    }
    
    static func doesThisUserExist(username: String) -> Bool
    {
        let users = fetchExistingUsersOnThisDevice { _ in
            #warning("handle this completion")
        }
        for user in users {
            if user.username == username { return true }
        }
        return false
    }
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH LOGO FLICKER STATUS
    
    static func saveLogoDidFlickerStatus(status: Bool)
    {
        do {
            let encoder = JSONEncoder()
            let encodedStatus = try encoder.encode(status)
            defaults.set(encodedStatus, forKey: PersistenceKeys.flickerStatusKey)
        } catch {
            print("failed to save ficker status")
        }
    }
    
    
    static func fetchLogoDidFlickerStatus() -> Bool
    {
        guard let statusToDecode = defaults.object(forKey: PersistenceKeys.flickerStatusKey) as? Data else { return false }
        
        do {
            let decoder = JSONDecoder()
            let decodedStatus = try decoder.decode(Bool.self, from: statusToDecode)
            return decodedStatus
        } catch {
            print("failed to load flicker status")
            return false
        }
    }
    
    //-------------------------------------//
    // MARK: - PASSWORD PERSISTENCE (KEYS ONLY - STORAGE = KEYCHAIN)
    
    
    
    //-------------------------------------//
    // MARK: - LOGIN PERSISTENCE
    
    static func updateLoggedInStatus(loggedIn: Bool) { defaults.set(loggedIn, forKey: PersistenceKeys.loginStatusKey) }
    
    
    static func fetchLoggedInStatus() -> Bool { return defaults.bool(forKey: PersistenceKeys.loginStatusKey) }
    // defaults.bool(forKey:) auto returns false if key doesn't yet exist
        
    //-------------------------------------//
    // MARK: - SAVE / FETCH VC VISIT STATUS
    
    static func saveVCVisitStatus(for vc: UIViewController, status: VCVisitStatusType) //.isFirstVisit || .isNotFirstVisit
    {
        switch vc {
        case is HomeCoursesVC:
            print("saving home vc visit status")
            do {
                let encoder = JSONEncoder()
                let encodedStatus = try encoder.encode(status)
                defaults.set(encodedStatus, forKey: VCVisitStatusType.homeVCVisitStatusKey)
            } catch {
                print("failed to save home courses vc visit status")
            }
            
        /**--------------------------------------------------------------------------**/

        case is CourseProjectsVC:
            print("saving projects vc visit status")
            do {
                let encoder = JSONEncoder()
                let encodedStatus = try encoder.encode(status)
                defaults.set(encodedStatus, forKey: VCVisitStatusType.projectsVCVisitStatusKey)
            } catch {
                print("failed to save course projects vc vist status")
            }
            
        /**--------------------------------------------------------------------------**/

        default:
            break
        }
    }
    
    
    static func fetchVCVisitStatus(for vc: UIViewController) -> VCVisitStatusType //.isFirstVisit || .isNotFirstVisit
    {
        switch vc {
        case is HomeCoursesVC:
            guard let statusToDecode = defaults.object(forKey: VCVisitStatusType.homeVCVisitStatusKey) as? Data
            else { return .isFirstVisit }
            
            do {
                let decoder = JSONDecoder()
                let fetchedStatus = try decoder.decode(VCVisitStatusType.self, from: statusToDecode)
                return fetchedStatus
            } catch {
                print("failed to load home courses vc visit status")
                return .isFirstVisit
            }
            
        /**--------------------------------------------------------------------------**/

        case is CourseProjectsVC:
            guard let vcVisitStatusData = defaults.object(forKey: VCVisitStatusType.projectsVCVisitStatusKey) as? Data
            else { return .isFirstVisit }
            
            do {
                let decoder = JSONDecoder()
                let fetchedStatus = try decoder.decode(VCVisitStatusType.self, from: vcVisitStatusData)
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
    // MARK: - SAVE / FETCH BOOKMARKS & COURSE COMPLETION
   
    static func updateProgress<T>(with item: T, actionType: ProgressType, completed: @escaping (SNError?) -> Void) -> Void
    where T: Codable, T: Identifiable, T: CourseItem
    {
        fetchProgress(forType: type(of: item)) { result in
            switch result {
            case .success(var progressArray):
                //see note 10.20 in app delegate
                handle(actionType, for: item, in: &progressArray) { error in
                    if error != nil { completed(error); return }
                }
                completed(saveAllProgress(for: progressArray))
            /**--------------------------------------------------------------------------**/
            case.failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func handle<T>(_ actionType: ProgressType, for item: T, in array: inout [T], completed: @escaping (SNError?) -> Void)
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
    
    
    static func fetchProgress<T>(forType fetchType: T.Type, completed: @escaping (Result<[T], SNError>) -> Void) -> Void
    where T: Codable, T: Identifiable, T: CourseItem
    {
        var key: String!
        
        switch fetchType {
        case is Course.Type:
            key = ProgressType.coursesProgressBinKey
        /**--------------------------------------------------------------------------**/
        case is CourseProject.Type:
            key = ProgressType.projectsProgressBinKey
        /**--------------------------------------------------------------------------**/
        default:
            break
        }
        
        #warning("I removed a '; return' after the 'else { completed(.success([]))' below. Was this okay?")
        guard let progressToDecode = defaults.object(forKey: key) as? Data
        else { completed(.success([])) }
        
        do {
            let decoder = JSONDecoder()
            let decodedProgress = try decoder.decode([T].self, from: progressToDecode)
            completed(.success(decodedProgress))
        } catch {
            completed(.failure(.failedToLoadProgress))
        }
    }
    
    
    static func saveAllProgress<T>(for items: [T]) -> SNError?
    where T: Codable
    {
        var key: String!
        
        switch T.self {
        case is Course.Type:
            key = ProgressType.coursesProgressBinKey
        /**--------------------------------------------------------------------------**/
        case is CourseProject.Type:
            key = ProgressType.projectsProgressBinKey
        /**--------------------------------------------------------------------------**/
        default:
            break
        }
        
        do {
            let encoder = JSONEncoder()
            let encodedCourseProgress = try encoder.encode(items)
            defaults.set(encodedCourseProgress, forKey: key)
            return nil
        } catch {
            return .failedToSaveProgress
        }
    }
}

