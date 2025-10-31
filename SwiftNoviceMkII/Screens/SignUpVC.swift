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
    
    
    func configureUsernameTextField()
    {
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: view.centerYAnchor),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func setPassword()
    {
        /**
         1. create a keychain item for each username-pasword pair
         */
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
}
