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

enum UserActionType { case addUser, removeUser }

enum FetchType { case courses, projects }

enum VCVisitStatusType: Codable
{
    case isFirstVisit, isNotFirstVisit
    static let homeVCVisitStatusKey = "homeVCVisitStatusKey"
    static let projectsVCVisitStatusKey = "projectsVCVisitStatusKey"
}
    
enum ProgressActionType
{
    case addBookmark, removeBookmark, markComplete, markIncomplete
    static let coursesProgressBinKey = "coursesProgressBinKey"
    static let projectsProgressBinKey = "projectsProgressBinKey"
}

//-------------------------------------//
// MARK: - MAIN PERSISTENCE MANAGER

enum PersistenceManager
{
    static private let defaults = UserDefaults.standard
//    static private var userCredentials = [UUID: CredentialBundle]()
    static var logoDidFlickerThisSession: Bool = fetchLogoDidFlickerStatus() {
        didSet { saveLogoDidFlickerStatus(status: logoDidFlickerThisSession) }
    }
        
    //-------------------------------------//
    // MARK: - EXISTING USERS PERSISTENCE
    
    static func saveNewUser(username: String, password: String)
    {
        var newUser = User(username: username, password: password) //needs to be stroed in keychain
        
        for cred in userCredentials {
            //pseudo: I wanna cast the UsernamePasswordBundle typealias to type 'Data' (- i cant, not allowed) to store in uuidString key
            KeychainWrapper.standard.set(cred.value.password, forKey: cred.key.uuidString)
        }
    }
    
    
    static func updateExistingUser(_ user: User)
    {
        
    }
    
    static func updateExistingUsersOnThisDevice(with user: User, actionType: UserActionType)
    {
        fetchExistingUsersOnThisDevice { result in
            switch result {
            case .success(var usersArray):
                break
            /**--------------------------------------------------------------------------**/
            case .failure(let error):
                break
            }
        }
    }
    
    
    static func fetchExistingUsersOnThisDevice(completed: @escaping (Result<[User], SNError>) -> Void) ->  Void
    {
        guard let usersToDecode = defaults.object(forKey: PersistenceKeys.existingUsersKey) as? Data
        else { completed(.success([])); return }
        
        do {
            let decoder = JSONDecoder()
            let decodedUsers = try decoder.decode([User].self, from: usersToDecode)
            completed(.success(decodedUsers))
        } catch {
            completed(.failure(.failedToFetchUser))
        }
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
    // MARK: - LOGIN PERSISTENCE
    
    static func updatePassword()
    {
        
    }
    
    
    static func savePassword(_ password: String) -> SNError?
    {
        KeychainWrapper.standard.set(password, forKey: PersistenceKeys.passwordKey)
        return nil
    }
    
    
    static func updateLoggedInStatus(loggedIn: Bool) { defaults.set(loggedIn, forKey: PersistenceKeys.loginStatusKey) }
    
    
    static func fetchLoggedInStatus() -> Bool { return defaults.bool(forKey: PersistenceKeys.loginStatusKey) }
        
    //-------------------------------------//
    // MARK: - SAVE / FETCH VC VISIT STATUS
    
    static func saveVCVisitStatus(for vc: UIViewController, status: VCVisitStatusType)
    {
        var key: String!
        
        /**--------------------------------------------------------------------------**/
        switch vc {
        case is HomeCoursesVC:
            key = VCVisitStatusType.homeVCVisitStatusKey
        case is CourseProjectsVC:
            key = VCVisitStatusType.projectsVCVisitStatusKey
        default:
            break
        }
        
        /**--------------------------------------------------------------------------**/
        do {
            let encoder = JSONEncoder()
            let encodedStatus = try encoder.encode(status)
            defaults.set(encodedStatus, forKey: key)
        } catch {
            print("Error: failed to save visitation status for this view controller")
        }
    }
    
    
    static func fetchVCVisitStatus(for vc: UIViewController) -> VCVisitStatusType
    {
        var key: String!
        
        /**--------------------------------------------------------------------------**/
        switch vc {
        case is HomeCoursesVC:
            key = VCVisitStatusType.homeVCVisitStatusKey
        case is CourseProjectsVC:
            key = VCVisitStatusType.projectsVCVisitStatusKey
        default:
            break
        }
        
        /**--------------------------------------------------------------------------**/
        guard let statusToDecode = defaults.object(forKey: key) as? Data
        else { return .isFirstVisit }
        
        do {
            let decoder = JSONDecoder()
            let fetchedStatus = try decoder.decode(VCVisitStatusType.self, from: statusToDecode)
            return fetchedStatus
        } catch {
            print("failed to load visitation status for this view controller")
            return .isFirstVisit
        }
    }
    
    //-------------------------------------//
    // MARK: - SAVE / FETCH PROGRESS (BOOKMARKS & COMPLETION)
   
    static func updateProgress<T>(with item: T, actionType: ProgressActionType, completed: @escaping (SNError?) -> Void) -> Void
    where T: Codable, T: Identifiable, T: CourseItem
    {
        fetchProgress(forType: type(of: item)) { result in
            switch result {
            case .success(var progressArray):
                //see note 10.20 in app delegate
                handle(actionType, for: item, in: &progressArray) { error in
                    if error != nil { completed(error) }
                }
                completed(saveAllProgress(for: progressArray))
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
        
        /**--------------------------------------------------------------------------**/
        switch fetchType {
        case is Course.Type:
            key = ProgressActionType.coursesProgressBinKey
        case is CourseProject.Type:
            key = ProgressActionType.projectsProgressBinKey
        default:
            break
        }
        
        /**--------------------------------------------------------------------------**/
        guard let progressToDecode = defaults.object(forKey: key) as? Data
        else { completed(.success([])); return }
        
        do {
            let decoder = JSONDecoder()
            let decodedProgress = try decoder.decode([T].self, from: progressToDecode)
            completed(.success(decodedProgress))
        } catch {
            completed(.failure(.failedToFetchProgress))
        }
    }
    
    
    static func handle<T>(_ actionType: ProgressActionType, for item: T, in array: inout [T], completed: @escaping (SNError?) -> Void)
    where T: Codable, T: Identifiable, T: CourseItem
    {
        var tmpItem = item
        array.removeAll { $0.id == item.id }
        
        /**--------------------------------------------------------------------------**/
        switch actionType {
        case .addBookmark:
            tmpItem.isBookmarked = true
        case .removeBookmark:
            tmpItem.isBookmarked = false
        case .markComplete:
            tmpItem.isCompleted = true
        case .markIncomplete:
            tmpItem.isCompleted = false
        }
        
        /**--------------------------------------------------------------------------**/
        array.append(tmpItem)
    }
    
    
    static func saveAllProgress<T>(for items: [T]) -> SNError?
    where T: Codable
    {
        var key: String!
        
        /**--------------------------------------------------------------------------**/
        switch T.self {
        case is Course.Type:
            key = ProgressActionType.coursesProgressBinKey
        
        case is CourseProject.Type:
            key = ProgressActionType.projectsProgressBinKey
        
        default:
            break
        }
        
        /**--------------------------------------------------------------------------**/
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
