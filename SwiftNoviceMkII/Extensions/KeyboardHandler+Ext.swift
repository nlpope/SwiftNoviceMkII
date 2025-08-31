//  File: KeyboardHandler+Ext.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 8/31/25.

import UIKit

//-------------------------------------//
// MARK: - SOLVE FOR KEYBOARD BLOCKING UI (by SwiftArcade)

extension UIViewController
{
    func setupKeyboardHiding()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification)
    {
        // get keyboard measurements & currently focused text field location
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentResponder() as? UITextField else { return }
        
        // check if keyboard top is above text field bottom (relative to superview)
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


extension UIResponder
{
    private struct Static
    {
        static weak var responder: UIResponder?
    }
    
    
    // determines which element onscreen triggered the keyboard
    static func currentResponder() -> UIResponder?
    {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap),
                                        to: nil,
                                        from: nil,
                                        for: nil)
        return Static.responder
    }
    
    
    @objc private func _trap() { Static.responder = self }
}
