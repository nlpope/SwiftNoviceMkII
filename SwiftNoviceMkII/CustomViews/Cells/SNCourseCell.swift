//  File: SNCourseCell.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/31/25.

import UIKit

class SNCourseCell: UICollectionViewCell
{
    static let reuseID = "CourseCell"
    let avatarImageView = SNAvatarImageView(frame: .zero)
    let courseNameLabel = SNTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    func set(course: Course)
    {
        courseNameLabel.text = course.name
//        avatarImageView.downloadImage(fromURL: course.avatarUrl)
    }
    
    
    private func configure()
    {
        addSubviews(avatarImageView, courseNameLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            courseNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            courseNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            courseNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            courseNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
