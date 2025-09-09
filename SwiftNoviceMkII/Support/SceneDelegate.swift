//  File: SceneDelegate.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = SNTabBarController()
        window?.makeKeyAndVisible()
        
        configNavBar()
    }
    
    
    func configNavBar()
    { UINavigationBar.appearance().tintColor = ColorKeys.oldGold }
    
    func sceneDidDisconnect(_ scene: UIScene)
    { PersistenceManager.isFirstVisitPostDismissal = true }
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene)
    { (UIApplication.shared.delegate as? AppDelegate)?.saveContext() }
}
