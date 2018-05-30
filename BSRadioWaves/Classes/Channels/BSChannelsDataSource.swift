// GNU General Public License v3.0
//
//  BSCategoriesDataSource.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/3/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSChannelsDataSource: NSObject, UICollectionViewDataSource {
    var channels: NSArray?
    private var collectionView: UICollectionView
    
    init(collectionView: UICollectionView) {
        self.channels = []
        
        self.collectionView = collectionView
        self.collectionView.register(UINib(nibName: BSChannelCell.reusableIdentifier, bundle: Bundle(for: BSChannelCell.self)), forCellWithReuseIdentifier: BSChannelCell.reusableIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.channels?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let channel = channels![indexPath.row] as! BSChannel
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: BSChannelCell.reusableIdentifier, for: indexPath) as! BSChannelCell
        cell.channel = channel
        cell.isFavorites = BSFavoritesManager.shared.isFavorites( id: channel.id!)
        cell.favoriteHandler = {
            (favorite) -> Void in
            if favorite {
                BSFavoritesManager.shared.addFavorites(id: channel.id!)
            } else {
                BSFavoritesManager.shared.removeFavorites(id: channel.id!)
            }
        }
        
        return cell
    }
}
