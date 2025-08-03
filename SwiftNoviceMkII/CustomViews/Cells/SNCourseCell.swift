//  File: SNCourseCell.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/31/25.

import UIKit

class SNCourseCell: UICollectionViewCell
{
    static let reuseID = "CourseCell"
    let avatarImageView = UIImageView(frame: .zero)
    let courseNameLabel: UILabel!
    
    
    func set(course: SNCourse)
    {
        courseNameLabel.tex
    }
}
func set(follower: Follower) {
    usernameLabel.text = follower.login
    avatarImageView.downloadImage(fromURL: follower.avatarUrl)
}
