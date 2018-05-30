// GNU General Public License v3.0
//
//  BSCategoryCell.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/3/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit
import SDWebImage

typealias BSLikeCellFavoriteHandler = (Bool) -> Void

class BSChannelCell: UICollectionViewCell {
    static let reusableIdentifier = "BSChannelCell"
    var favoriteHandler: BSLikeCellFavoriteHandler?
    var isFavorites: Bool = false {
        didSet {
            self.updateFavorites()
        }
    }
    
    var channel: BSChannel? {
        didSet {
            load()
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var loadingView: BSWavesView!
    @IBOutlet var favoritesImageView: UIImageView!
    
    @IBAction func favorites(_ sender: UIButton) {
        self.animateImageTap(imageView: self.favoritesImageView, parentView: self)
        self.isFavorites = !self.isFavorites
        self.favoriteHandler!(self.isFavorites)
    }
    
    func load() {
        self.titleLabel.text = self.channel?.name
        
        self.loadingView.isHidden = false
        self.loadingView.isActive = true
        
        if self.channel?.image != nil {
            self.imageView.sd_setImage(with: URL(string: "http:" + (self.channel?.image!)!), completed: { (image, error, cacheType, url) in
                self.loadingView.isHidden = image != nil
                self.loadingView.isActive = image == nil
            })
        }
    }
    
    func updateFavorites() {
        let imageName = self.isFavorites ? "starFullIcon" : "starEmptyIcon"
        self.favoritesImageView.image = UIImage(named: imageName)
    }
}
