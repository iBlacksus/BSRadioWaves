// GNU General Public License v3.0
//
//  BSCategoriesTableView.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/3/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

typealias BSChannelsViewChannelOffsetHandler = (CGPoint) -> Void

class BSChannelsView: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var viewController: UIViewController?
    var selectedChannel: BSChannel?
    var channelOffsetHandler: BSCategoryCellChannelOffsetHandler?
    
    var channels: NSArray? {
        didSet {
            self.channelsDataSource?.channels = self.channels
            self.reloadData()
        }
    }
    var channelsDataSource: BSChannelsDataSource?
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        self.channelsDataSource = BSChannelsDataSource(collectionView: self)
        self.dataSource = self.channelsDataSource
        self.delegate = self
        self.backgroundColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerViewControllerDidLoad(notification:)),
                                               name: NSNotification.Name.BSPlayerViewControllerDidLoad,
                                               object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let dataSource = self.dataSource as? BSChannelsDataSource
        let channel = dataSource?.channels![indexPath.row] as? BSChannel
        self.selectedChannel = channel!
        
        NotificationCenter.default.post(name: Notification.Name.BSTabBarControllerSelectTab, object: 1)
        NotificationCenter.default.post(name: Notification.Name.BSPlayerViewControllerChangeChannel, object: self.selectedChannel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let size = self.frame.width / 2 - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right
        return CGSize(width: size, height: size + 40.0)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrolledToPoint()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            return
        }
        
        self.scrolledToPoint()
    }
    
    func scrolledToPoint() {
        let point = CGPoint(x: self.contentOffset.x, y: self.contentOffset.y)
        self.channelOffsetHandler?(point)
    }
    
    @objc func playerViewControllerDidLoad(notification: Notification) {
        NotificationCenter.default.post(name: Notification.Name.BSPlayerViewControllerChangeChannel, object: self.selectedChannel)
    }
}
