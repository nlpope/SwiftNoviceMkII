//  File: SignInVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 10/14/25.

import UIKit

class SignInVC: UIViewController, UITextFieldDelegate
{
    let logoImageView = UIImageView()
    let usernameTextField = SNTextField(placeholder: "username")
    let passwordTextField = SNTextField(placeholder: "password")
    let signInLabel = SNInteractiveLabel(textToDisplay: "Sign in", fontSize: 18)
    let signUpLabel = SNInteractiveLabel(textToDisplay: "Don't have an account?", fontSize: 18)
    let forgotLabel = SNInteractiveLabel(textToDisplay: "Forgot username/password?", fontSize: 18)
    
    var passwordIsCorrect: Bool!
    var isUsernameEntered: Bool { return !usernameTextField.text!.isEmpty }
    var isPasswordEntered: Bool { return !passwordTextField.text!.isEmpty }
    
    var loggedInUser: User! 
    
    var logoLauncher: SNLogoLauncher!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureVC()
        configLogoImageView()
        configUsernameTextField()
        configPasswordTextField()
        configSignInLabel()
        configSignUpLabel()
        configForgotLabel()
        fetchExistingUsers()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
        configKeyboardBehavior()
        print("gesture recognizers = \(view.gestureRecognizers!)")
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        logoLauncher = nil
        view.gestureRecognizers?.removeAll()
    }
    
   
    //-------------------------------------//
    // MARK: - EXISTING USER FETCHING
    #warning("wouldn't you want the existing users to be bundled w their passwords in the keychain?")
    func fetchExistingUsers()
    {
        PersistenceManager.fetchExistingUsers { result in
            switch result {
            case .success(var existingUsers):
                self.existingUsers = existingUsers
            case .failure(let error):
                self.presentSNAlertOnMainThread(forError: error)
            }
        }
    }
    
    //-------------------------------------//
    // MARK: - SIGN UP & PASSWORD RESET METHODS
    

    
    
    @objc func presentSignUpVC()
    {
        print("it works")
    }
    
    
    @objc func presentPasswordReset()
    {
        print("it works")
    }
    
    //-------------------------------------//
    // MARK: - PASSWORD ACCEPTED BEHAVIOR METHODS
    
    @objc func verifyUserAndResetRootVC()
    {
        guard isUsernameEntered, isPasswordEntered
        else { presentSNAlertOnMainThread(forError: .emptyFields); return }
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
                
        PersistenceManager.fetchUser(withUsername: username, password: password) { [self] result in
            switch result {
            case .success(let user):
                PersistenceManager.activeUser = user
                usernameTextField.resignFirstResponder()
                passwordTextField.resignFirstResponder()
                let tabBarController = SNTabBarController()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(tabBarController)
                
            /**--------------------------------------------------------------------------**/
            case .failure(let error):
                presentSNAlertOnMainThread(forError: error)
            }
        }
    }

    //-------------------------------------//
    // MARK: - KEYBOARD METHODS
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        verifyUserAndResetRootVC()
        return true
    }
}
