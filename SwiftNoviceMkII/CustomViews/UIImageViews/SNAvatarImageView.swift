//  File: SNAvatarImageView.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/31/25.

import UIKit

class SNAvatarImageView: UIImageView
{
    let cache = NetworkManager.shared.cache
    let placeholderImage = ImageKeys.placeholder
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    private func configure()
    {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func downloadImage(fromURL url: String)
    {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async { self?.image = image }
        }
    }
}
