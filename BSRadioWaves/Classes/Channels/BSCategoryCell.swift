// GNU General Public License v3.0
//
//  BSCategoryCell.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/3/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

typealias BSCategoryCellPrevHandler = () -> Void
typealias BSCategoryCellNextHandler = () -> Void
typealias BSCategoryCellChannelOffsetHandler = (CGPoint) -> Void

class BSCategoryCell: UICollectionViewCell, UIScrollViewDelegate {
    static let reusableIdentifier = "BSCategoryCell"
    
    var prevHandler: BSCategoryCellPrevHandler?
    var nextHandler: BSCategoryCellNextHandler?
    var channelOffsetHandler: BSCategoryCellChannelOffsetHandler? {
        didSet {
            self.collectionView.channelOffsetHandler = self.channelOffsetHandler
        }
    }
    var category: BSCategory? {
        didSet {
            load()
        }
    }
    var isFirstCategory = false {
        didSet {
            self.leftButton.isHidden = self.isFirstCategory
        }
    }
    var isLastCategory = false {
        didSet {
            self.rightButton.isHidden = self.isLastCategory
        }
    }
    var channelsOffset: CGPoint? {
        didSet {
            self.collectionView.contentOffset = self.channelsOffset!
        }
    }
    
    @IBOutlet var collectionView: BSChannelsView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    func load() {
        self.collectionView.channels = self.category?.channels as NSArray?
        self.titleLabel.text = category?.name
    }
    
    @IBAction func left(_ sender: UIButton) {
        self.prevHandler?()
    }
    
    @IBAction func right(_ sender: UIButton) {
        self.nextHandler?()
    }
}
