//  File: SignUpVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 10/29/25.

import UIKit

// to be presented not pushed
// saves the user account to user defaults on completion  (check for duplicates)
// ... then sets the rootVC back to sign in once complete

protocol SignUpVCDelegate: AnyObject
{
    func createAccount()
}

class SignUpVC: UIViewController, UITextFieldDelegate
{
    let usernameTextField           = SNTextField(placeholder: "username")
    let passwordTextField           = SNTextField(placeholder: "password")
    let confirmPasswordTextField    = SNTextField(placeholder: "confirm password")
    let signInLabel                 = SNInteractiveLabel(textToDisplay: "Sign in", fontSize: 18)
    
    weak var delegate: SignUpVCDelegate!
    let padding: CGFloat = 20

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureVC()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func configureVC()
    {
        view.backgroundColor = .systemBackground
        view.addSubviews(usernameTextField, passwordTextField, confirmPasswordTextField, signInLabel)
    }
    
    
    func createDismissKeyboardTapGesture()
    {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
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
    
    
    @objc func resetRootVC()
    {
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resetRootVC()
        return true
    }
}

//extension SignUpVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return menuOptions.count
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell                = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        let menuOption          = menuOptions[indexPath.row]
//        cell.textLabel?.text    = menuOption
//        if menuOption == "Delete Account" { cell.textLabel?.textColor = .systemRed }
//
//        return cell
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let selectedOption = menuOptions[indexPath.row]
//
//        if selectedOption == "Sign Out" { delegate.signOut() }
//        else if selectedOption == "Edit password" { delegate.editPassword() }
//        else if selectedOption == "See instructions" { delegate.seeInstructions() }
//        else if selectedOption == "Delete Account" { delegate.deleteAccount() }
//    }
//}

