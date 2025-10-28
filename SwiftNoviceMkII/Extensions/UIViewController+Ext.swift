//  File: UIViewController+Ext.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/23/25.

import UIKit
import SafariServices

extension UIViewController
{
    func presentSNAlertOnMainThread(forError error: SNError?)
    {
        let title: String!
        let message: String!
        
    /**--------------------------------------------------------------------------**/
        switch error {
            
        case .emptyFields:
            title = "Empty username or password"
            message = SNError.emptyFields.rawValue
        case .pwdAndCpwdMismatch:
            title = "Mismatch detected"
            message = SNError.pwdAndCpwdMismatch.rawValue
        case .wrongUsernameOrPwd:
            title = "Wrong username or password"
            message = SNError.wrongUsernameOrPwd.rawValue
        case .noBiometry:
            title = "No biometry detected"
            message = SNError.noBiometry.rawValue
        case .authFail:
            title = "Authentication failure"
            message = SNError.authFail.rawValue
            
        /**--------------------------------------------------------------------------**/
        case .failedToFetchUser:
            title = "Failed to find user"
            message = SNError.failedToFetchUser.rawValue
        case .failedToSaveUser:
            title = "Failed to save user"
            message = SNError.failedToSaveUser.rawValue
        case .failedToSaveProgress:
            title = "Failed to save progress"
            message = SNError.failedToSaveProgress.rawValue
        case .failedToFetchProgress:
            title = "Failed to fetch progress"
            message = SNError.failedToFetchProgress.rawValue
            
        /**--------------------------------------------------------------------------**/
        case .badURL:
            title = "Bad URL"
            message = SNError.badURL.rawValue
        case .badResponse:
            title = "Bad response"
            message = SNError.badResponse.rawValue
        case .badData:
            title = "Bad data"
            message = SNError.badData.rawValue
        case .errorDecodingData:
            title = "Error decoding data"
            message = SNError.errorDecodingData.rawValue
            
        /**--------------------------------------------------------------------------**/
        default:
            title = "Bad stuff happened"
            message = "Something went wrong. Please try again."
        }
        
    /**--------------------------------------------------------------------------**/
        
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
    
    #warning("make sure these are working on each vc via the view.gestureRecognizers call after the below is called. Have a sneaking suspicion this may need to be defined per vc instead of just here... or sumn more condensed")
    func configKeyboardBehavior()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        createDismissKeyboardTapGesture()
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
    
    
    func createDismissKeyboardTapGesture()
    {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)        
    }
}
