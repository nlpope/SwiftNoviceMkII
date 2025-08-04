//  File: CourseProjectsVC.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 8/4/25.

import UIKit

class CourseProjectsVC
{
    /**
     incorporate following from ghfollowers: follwerlistvc
     
     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
         let offsetY         = scrollView.contentOffset.y
         let contentHeight   = scrollView.contentSize.height
         let height          = scrollView.frame.size.height
         
         if offsetY > contentHeight - height {
             guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
             page += 1
             getFollowers(username: username, page: page)
         }
     }
     
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         // pass login onto userinfoVC
         // present userinfoVC
         let activeArray     = isSearching ? filteredFollowers : followers
         let follower        = activeArray[indexPath.item]
         
         let destVC          = UserInfoVC()
         destVC.username     = follower.login
         destVC.delegate     = self
         
         let navController   = UINavigationController(rootViewController: destVC)
         present(navController, animated: true)
     }
     */
}
