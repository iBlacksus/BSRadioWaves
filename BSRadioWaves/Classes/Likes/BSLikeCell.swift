// GNU General Public License v3.0
//
//  BSLikeCell.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/15/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

typealias BSLikeCellUnlikeHandler = () -> Void
typealias BSLikeCellShareHandler = () -> Void

class BSLikeCell: UICollectionViewCell {
    static let reusableIdentifier = "BSLikeCell"
    
    var unlikeHandler: BSLikeCellUnlikeHandler?
    var shareHandler: BSLikeCellShareHandler?
    var halfUnlike = false
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var unlikeImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
    }
    
    static func size(collectionView: UICollectionView) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60.0)
    }
    
    var title: NSString? {
        didSet {
            load()
        }
    }
    
    func load() {
        self.titleLabel.text = self.title as String?
        self.undoUnlike(animation: false)
    }
    
    func undoUnlike(animation: Bool = true) {
        if self.halfUnlike == false {
            return
        }
        
        self.animateImageTap(imageView: self.unlikeImageView, parentView: self)
        self.halfUnlike = false
        self.unlikeImageView.image = UIImage(named: "brokenHeartIcon")
    }
    
    @IBAction func unlike(_ sender: UIButton) {
        if halfUnlike {
            self.animateImageTap(imageView: self.unlikeImageView, parentView: self)
            self.unlikeHandler!()
            return
        }
        
        self.animateImageTap(imageView: self.unlikeImageView, parentView: self)
        self.halfUnlike = true
        self.unlikeImageView.image = UIImage(named: "halfHeartIcon")
//        self.perform(#selector(self.undoUnlike), with: nil, afterDelay: 3.0)
        
        let deadlineTime = DispatchTime.now() + .milliseconds(100)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.undoUnlike()
        }
    }
    
    @IBAction func share(_ sender: UIButton) {
        self.shareHandler!()
        self.animateImageTap(imageView: self.shareImageView, parentView: self)
    }
}
