//  File: SNInteractiveLabel.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 10/20/25.

import UIKit

class SNInteractiveLabel: UILabel
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    convenience init(textToDisplay: String, fontSize: CGFloat)
    {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        text = textToDisplay
    }
    
    
    private func configure()
    {
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
    }
}
