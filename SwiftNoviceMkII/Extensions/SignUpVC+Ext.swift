//  File: SignUpVC+Ext.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 10/30/25.

import UIKit

extension SignUpVC
{
    //-------------------------------------//
    // MARK: - CONFIGURATION
    
    func configVC()
    {
        view.backgroundColor = .systemBackground
        view.addSubviews(usernameTextField, passwordTextField, confirmPasswordTextField, createAccountLabel)
    }
    
    
    func configUsernameTextField()
    {
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: view.centerYAnchor),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configPasswordTextField()
    {
        
    }
    
    
    func configConfirmPasswordTextField()
    {
        
    }
    
    
    func configCreateAccountLabel()
    {
        
    }
    
}
