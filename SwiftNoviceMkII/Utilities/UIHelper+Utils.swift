//  File: UIHelper+Utils.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/30/25.

import UIKit

enum UIHelper
{
    static func createThreeColumnLayout(in view: UIView) -> UICollectionViewFlowLayout
    {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
//        flowLayout.collectionView?.contentSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
}
