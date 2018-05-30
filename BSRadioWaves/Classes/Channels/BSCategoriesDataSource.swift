// GNU General Public License v3.0
//
//  BSCategoriesDataSource.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/3/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSCategoriesDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var categories: NSMutableArray? {
        didSet {
            self.configureFavorites()
        }
    }
    private var collectionView: UICollectionView
    private var cellOffsets: NSMutableDictionary?
    
    init(collectionView: UICollectionView) {
        self.cellOffsets = NSMutableDictionary()
        self.categories = []
        self.collectionView = collectionView
        self.collectionView.register(UINib(nibName: BSCategoryCell.reusableIdentifier, bundle: Bundle(for: BSCategoryCell.self)), forCellWithReuseIdentifier: BSCategoryCell.reusableIdentifier)
    }
    
    func configure() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.favoritesManagerUpdated(notification:)),
                                               name: NSNotification.Name.BSFavoritesManagerUpdated,
                                               object: nil)
    }
    
    @objc func favoritesManagerUpdated(notification: Notification) {
        self.configureFavorites(reloadData: false)
        self.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
    }
    
    func configureFavorites(reloadData: Bool = true) {
        var category = BSCategory()
        var favoritesExists = false
        for item in self.categories! {
            let categoryItem = item as! BSCategory
            if categoryItem.isFavorite {
                category = categoryItem
                favoritesExists = true
                break
            }
        }
        
        category?.name = "Favorites"
        category?.isFavorite = true
        
        let favorites = NSMutableArray()
        let ids = NSMutableSet()
        
        for item in self.categories! {
            let categoryItem = item as! BSCategory
            for channel in categoryItem.channels! {
                if ids.contains(channel.id!) {
                    continue
                }
                
                if BSFavoritesManager.shared.isFavorites(id: channel.id!) {
                    favorites.add(channel)
                    ids.add(channel.id!)
                }
            }
        }
        
        category?.channels = favorites as? [BSChannel]
        
        let categoriesCountOld = self.categories?.count
        let indexPath = IndexPath(item: 0, section: 0)
        var x = self.collectionView.contentOffset.x
        if favorites.count > 0 && !favoritesExists {
            categories?.insert(category!, at: 0)
            if !reloadData {
                UIView.performWithoutAnimation {
                    self.collectionView.insertItems(at: [indexPath])
                }
            }
        } else if favorites.count == 0 && favoritesExists {
            categories?.remove(category!)
            if !reloadData {
                UIView.performWithoutAnimation {
                    self.collectionView.deleteItems(at: [indexPath])
                }
            }
        }
        
        if categoriesCountOld != self.categories?.count {
            let collection: BSCategoriesView = self.collectionView as! BSCategoriesView
            let cellWidth = collection.collectionView(collection, layout: collection.collectionViewLayout, sizeForItemAt: indexPath).width
            x += (self.categories?.count)! > categoriesCountOld! ? cellWidth : -cellWidth
            x = max(x, 0)
            
            if reloadData {
                self.collectionView.reloadData()
                x = 0
            } else {
                UIView.performWithoutAnimation {
                    self.collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
                }
            }
            
            let point = CGPoint(x: x, y: self.collectionView.contentOffset.y)
            self.collectionView.setContentOffset(point, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.categories?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = self.categories![indexPath.row] as! BSCategory
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: BSCategoryCell.reusableIdentifier, for: indexPath) as! BSCategoryCell
        cell.category = category
        cell.isFirstCategory = indexPath.row == 0
        cell.isLastCategory = indexPath.row == (self.categories?.count)! - 1
        if cellOffsets![indexPath.row] != nil {
            cell.channelsOffset = self.cellOffsets![indexPath.row] as? CGPoint
        } else {
            cell.channelsOffset = CGPoint(x: 0, y: 0)
        }
        cell.prevHandler = {
            () -> Void in
            self.scrollTo(indexPath: indexPath, next: false)
        }
        cell.nextHandler = {
            () -> Void in
            self.scrollTo(indexPath: indexPath, next: true)
        }
        cell.channelOffsetHandler = {
            (offset) -> Void in
            self.cellOffsets![indexPath.row] = offset
        }
        
        return cell
    }
    
    func scrollTo(indexPath: IndexPath, next: Bool) {
        var row = indexPath.row
        row += next ? 1 : -1
        row = max(row, 0)
        row = min(row, (self.categories?.count)!)
        let newIndexPath = IndexPath(item: row, section: 0)
        self.collectionView.isUserInteractionEnabled = false
        self.collectionView.scrollToItem(at: newIndexPath, at: UICollectionViewScrollPosition.left, animated: true)
        let deadlineTime = DispatchTime.now() + .milliseconds(250)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.collectionView.isUserInteractionEnabled = true
        }
    }
}
