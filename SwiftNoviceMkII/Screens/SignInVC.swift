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
    
    var existingUsers: [User]!
    var userExists: Bool!
    
    var passwordIsCorrect: Bool!
    var isUsernameEntered: Bool { return !usernameTextField.text!.isEmpty }
    var isPasswordEntered: Bool { return !passwordTextField.text!.isEmpty }
    
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
    
    func fetchExistingUsers()
    {
        PersistenceManager.fetchExistingUsersOnThisDevice { result in
            switch result {
            case .success(var existingUsers):
                self.existingUsers = existingUsers
            case .failure(let error):
                self.presentSNAlertOnMainThread(forError: error)
            }
        }
    }
    
    //-------------------------------------//
    // MARK: - PASSWORD CREATION (SIGN UP) METHODS
    
    @objc func setPassword()
    {
        let ac = UIAlertController(title: "Set Password",
                                   message: "Set your secure password",
                                   preferredStyle: .alert)
        for _ in 0 ... 1 { ac.addTextField() }
        for i in 0 ... 1 { ac.textFields?[i].isSecureTextEntry = true }
        ac.textFields?[0].placeholder = "enter password"
        ac.textFields?[1].placeholder = "confirm password"
        
        let action1 = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            guard let pwd = ac.textFields?[0].text
            else { self?.presentSNAlertOnMainThread(forError: .emptyFields); return }
            
            guard let cPwd = ac.textFields?[1].text
            else { self?.presentSNAlertOnMainThread(forError: .emptyFields); return }
            
            guard pwd == cPwd
            else { self?.presentSNAlertOnMainThread(forError: .pwdAndCpwdMismatch); return }

            #warning("what did i mean by the below comment?")
            // AFTER THIS INCORPORATE REST OF KEYS IN THE POST SET PWD ENTRY METHOD
            KeychainWrapper.standard.set(pwd, forKey: PersistenceKeys.passwordKey)
        }
        
        ac.addAction(action1)
        present(ac, animated: true)
    }
    
    
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
    
    @objc func verifyAndResetRootVC()
    {
        PersistenceManager.fetchExistingUsersOnThisDevice { [self] result in
            switch result {
            case .success(let users):
//                self.existingUsers = users
                for user in users { if user.username.lowercased() == usernameTextField.text?.lowercased() {
                    userExists = true; break
                }}
            case .failure(_):
                self.presentSNAlertOnMainThread(forError: .failedToFetchUser)
            }
        }
        
        guard isUsernameEntered, isPasswordEntered
        else { presentSNAlertOnMainThread(forError: .emptyFields); return }

        guard userExists, passwordIsCorrect
        else { presentSNAlertOnMainThread(forError: .wrongUsernameOrPwd); return }
        
        #warning("look into the below - is it what you want in the final version?")
        updateLoggedinStatus(withStatus: true)
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        let tabBarController = SNTabBarController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(tabBarController)
    }
    
    //-------------------------------------//
    // MARK: - LOGIN STATUS UPDATER
    
    func updateLoggedinStatus(withStatus status: Bool) { PersistenceManager.updateLoggedInStatus(loggedIn: status) }

    //-------------------------------------//
    // MARK: - KEYBOARD METHODS
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        verifyAndResetRootVC()
        return true
    }
}
