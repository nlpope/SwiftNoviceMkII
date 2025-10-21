//  File: SNTextField.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 10/20/25.

import UIKit

class SNTextField: UITextField
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been impemented") }
    
    
    convenience init(placeholder: String)
    {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }
    
    private func configure()
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        returnKeyType = .go
        clearButtonMode = .whileEditing
        placeholder = ""
    }
}
