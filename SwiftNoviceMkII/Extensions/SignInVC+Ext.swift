//  File: SignInVC+Ext.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 10/28/25.

import UIKit

extension SignInVC
{
    //-------------------------------------//
    // MARK: - CONFIGURATION
    
    func configureVC()
    {
        view.backgroundColor = .systemBackground
        view.addSubviews(logoImageView, usernameTextField, passwordTextField, signInLabel, signUpLabel, forgotLabel)
    }
    
    
    func configLogoImageView()
    {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = ImageKeys.placeholder
        
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    func configUsernameTextField()
    {
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configPasswordTextField()
    {
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 50),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configSignInLabel()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(verifyUserAndResetRootVC))
        signInLabel.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            signInLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            signInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    func configSignUpLabel()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentSignUpVC))
        signUpLabel.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            signUpLabel.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 50),
            signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    func configForgotLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentSignUpVC))
        forgotLabel.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            forgotLabel.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 50),
            forgotLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}
