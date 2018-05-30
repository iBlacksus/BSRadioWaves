// GNU General Public License v3.0
//
//  BSLikesView.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/15/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit
import Toast_Swift

class BSLikesView: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    var viewController: UIViewController?
    
    var likes: NSMutableArray? {
        didSet {
            self.likesDataSource?.likes = self.likes!
            self.reloadData()
        }
    }
    var likesDataSource: BSLikesDataSource?
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        self.likesDataSource = BSLikesDataSource(collectionView: self)
        self.dataSource = self.likesDataSource
        self.delegate = self
        self.backgroundColor = UIColor.clear
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = self.likes?[indexPath.row] as! String
        UIPasteboard.general.string = title
        
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let cellRect: CGRect = (attributes?.frame)!
        let view: UIView = collectionView.superview!
        let cellFrameInSuperview = collectionView.convert(cellRect, to: view)
        let position = CGPoint(x: cellFrameInSuperview.midX, y: cellFrameInSuperview.midY)
        
        self.makeToast("Copied to clipboard", duration: 1.25, position: position)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return BSLikeCell.size(collectionView: collectionView)
    }
}
