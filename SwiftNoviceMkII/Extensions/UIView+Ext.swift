//  File: UIView+Ext.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 8/2/25.

import UIKit

extension UIView
{
    func addSubviews(_ views: UIView...) { for view in views { addSubview(view) } }
}
