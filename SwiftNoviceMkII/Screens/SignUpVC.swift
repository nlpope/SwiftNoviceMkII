//  File: SignUpVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 10/29/25.

import UIKit
import LocalAuthentication

protocol SignUpVCDelegate: AnyObject
{
    func createAccount()
}

class SignUpVC: UIViewController, UITextFieldDelegate
{
    let usernameTextField = SNTextField(placeholder: "username")
    let passwordTextField = SNTextField(placeholder: "password")
    let confirmPasswordTextField = SNTextField(placeholder: "confirm password")
    let createAccountLabel = SNInteractiveLabel(textToDisplay: "Create Account", fontSize: 18)
    
    weak var delegate: SignUpVCDelegate!
    let padding: CGFloat = 20
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configVC()
        configUsernameTextField()
        configPasswordTextField()
        configConfirmPasswordTextField()
        configCreateAccountLabel()
    }
    
    
    #warning("test your taps on each vc and if it cancels the keyboard b/c it may not given the scope of all this")
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
        configKeyboardBehavior()
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        view.gestureRecognizers?.removeAll()
    }
    
    
    @objc func createNewUser()
    {
        let ac = UIAlertController(title: "Sign Up",
                                   message: "Set your username and secure password",
                                   preferredStyle: .alert)
        
        for _ in 0 ... 2 { ac.addTextField() }
        for i in 1 ... 2 { ac.textFields?[i].isSecureTextEntry = true }
        ac.textFields?[0].placeholder = "enter username"
        ac.textFields?[1].placeholder = "enter password"
        ac.textFields?[2].placeholder = "confirm password"
        
        let action1 = UIAlertAction(title: "Create Account", style: .default) { [weak self] _ in
            guard let username = ac.textFields?[0].text
            else { self?.presentSNAlertOnMainThread(forError: .emptyFields); return }
            
            guard let password = ac.textFields?[1].text
            else { self?.presentSNAlertOnMainThread(forError: .emptyFields); return }
            
            guard let confirmedPassword = ac.textFields?[2].text
            else { self?.presentSNAlertOnMainThread(forError: .emptyFields); return }
            
            guard password == confirmedPassword
            else { self?.presentSNAlertOnMainThread(forError: .pwdAndCpwdMismatch); return }
            
            PersistenceManager.createNewUser(withUsername: username, password: password)
        }
        
        ac.addAction(action1)
        present(ac, animated: true)
    }
}
