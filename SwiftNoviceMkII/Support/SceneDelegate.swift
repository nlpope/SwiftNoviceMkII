//  File: SceneDelegate.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        #warning("dismiss the signInVC then use instruments to avoid memory leak")
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
//        window?.rootViewController = determineRootVC()
        window?.rootViewController = SignInVC()
        window?.makeKeyAndVisible()
        
        configNavBar()
    }
    
    
    func determineRootVC() -> UIViewController
    {        
        //then in playerDidFinishPlaying() check persMgr for signin status
        //if signed in change root vc to tabBarVC
        //if not signed in keep root vc as signinVC
        let userIsLoggedIn = PersistenceManager.fetchLoggedInStatus()
        guard userIsLoggedIn else { return SignInVC() }
        return SNTabBarController()
    }
    
    
    func changeRootVC(_ vc: UIViewController, animated: Bool = true)
    {
        guard let window = self.window else { return }
        window.rootViewController = vc
    }
    
    
    func configNavBar() { UINavigationBar.appearance().tintColor = ColorKeys.oldGold }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) { PersistenceManager.logoDidFlickerThisSession = false }
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) { (UIApplication.shared.delegate as? AppDelegate)?.saveContext() }
}
