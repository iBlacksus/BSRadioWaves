// GNU General Public License v3.0
//
//  BSLikesDataSource.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/15/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSLikesDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var likes: NSMutableArray {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private var collectionView: BSLikesView
    
    init(collectionView: UICollectionView) {
        self.likes = NSMutableArray()
        self.collectionView = collectionView as! BSLikesView
        self.collectionView.register(UINib(nibName: BSLikeCell.reusableIdentifier, bundle: Bundle(for: BSLikeCell.self)), forCellWithReuseIdentifier: BSLikeCell.reusableIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.likes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title = self.likes[indexPath.row] as! NSString
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: BSLikeCell.reusableIdentifier, for: indexPath) as! BSLikeCell
        cell.title = title
        cell.unlikeHandler = {
            () -> Void in
            self.likes.remove(title)
            let cellIndexPath = self.collectionView.indexPath(for: cell)
            self.collectionView.deleteItems(at: [cellIndexPath!])
//            self.perform(#selector(self.unlike(title:)), with: title, afterDelay: 0.25)
            let deadlineTime = DispatchTime.now() + .milliseconds(100)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.unlike(title: title as String)
            }
        }
        
        cell.shareHandler = {
            () -> Void in
            self.share(title: title as String)
        }
        
        return cell
    }
    
    func unlike(title: String) {
        BSLikesManager.removeLike(string: title)
    }
    
    func share(title: String) {
        let objectsToShare = [title]
        let controller = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        controller.popoverPresentationController?.sourceView = self.collectionView
        self.collectionView.viewController?.present(controller, animated: true, completion: nil)
    }
}
