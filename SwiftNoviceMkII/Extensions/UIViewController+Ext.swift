//  File: UIViewController+Ext.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit
import SafariServices

extension UIViewController
{
    func presentSNAlertOnMainThread(alertTitle: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default))
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            
            self.present(alertVC, animated: true)
        }
    }
    
    
    func presentSafariVC(with url: URL)
    {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
    //-------------------------------------//
    // MARK: - SOLVE FOR KEYBOARD BLOCKING TEXTFIELD (by SwiftArcade)
    
    func setupKeyboardHiding()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification)
    {
        print("successfully accessing keyboardWillShow method")
        // get keyboard measurements & currently focused text field location
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              // see note 13 in app delegate
              let currentTextField = UIResponder.currentResponder() as? UITextField else { return }
        
        // check if keyboard top is above text field bottom (relative to superview)
        // see note 14 in app delegate
        let keyboardTopY        = keyboardFrame.cgRectValue.origin.y
        let textFieldBottomY    = currentTextField.frame.origin.y + currentTextField.frame.size.height
        
        // bump view up if so: moving up/left = negative val, moving down/right = positive val
        if textFieldBottomY > keyboardTopY {
            let textFieldTopY   = currentTextField.frame.origin.y
            let newFrameY       = (textFieldTopY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY
        }
    }
    
    
    @objc func keyboardWillHide(sender: NSNotification) { view.frame.origin.y = 0 }
}
