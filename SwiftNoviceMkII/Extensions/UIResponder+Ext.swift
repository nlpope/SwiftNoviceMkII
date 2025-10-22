//  File: UIResponder+Ext.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 10/21/25.

import UIKit

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
