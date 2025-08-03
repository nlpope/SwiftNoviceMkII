//  File: SNCourseCell.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/31/25.

import UIKit

class SNCourseCell: UICollectionViewCell
{
    static let reuseID = "CourseCell"
    let avatarImageView = SNAvatarImageView(frame: .zero)
    let courseNameLabel = SNTitleLabel(textAlignment: .center, fontSize: 16)
    
    
    func set(course: SNCourse)
    {
        courseNameLabel.text = course.name
    }
}
