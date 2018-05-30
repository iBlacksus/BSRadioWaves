// GNU General Public License v3.0
//
//  BSCategoriesTableView.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/3/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

typealias BSCategoriesViewUpdateCompletion = () -> Void

class BSCategoriesView: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    var viewController: UIViewController?
    var musicManager: BSMusicManagerProtocol?
    private var categoriesDataSource: BSCategoriesDataSource?
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        self.categoriesDataSource = BSCategoriesDataSource(collectionView: self)
        self.categoriesDataSource?.configure()
        self.dataSource = self.categoriesDataSource
        self.delegate = self
    }
    
    func update(completion: @escaping BSCategoriesViewUpdateCompletion) {
        self.musicManager?.getCategories { (categories) in
            let dataSource = self.dataSource as? BSCategoriesDataSource
            dataSource?.categories = categories.mutableCopy() as? NSMutableArray
            self.reloadData()
            
            completion()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollToNearestCategory()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            return
        }
        
        self.scrollToNearestCategory()
    }
    
    func scrollToNearestCategory() {
        let x = round(self.contentOffset.x / self.frame.width) * self.frame.width
        let rect = CGRect(x: x, y: 0, width: self.frame.width, height: self.frame.height)
        self.scrollRectToVisible(rect, animated: true)
    }
}
