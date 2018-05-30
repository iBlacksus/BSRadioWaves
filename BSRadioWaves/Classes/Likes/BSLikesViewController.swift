// GNU General Public License v3.0
//
//  BSLikesViewController.swift
//  BSRadioWaves
//
//  Created by Oleg Musinov on 11/12/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSLikesViewController: UIViewController {
    @IBOutlet var collectionView: BSLikesView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.collectionView.viewController = self
        self.collectionView.likes = BSLikesManager.getLikes().mutableCopy() as? NSMutableArray
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.likesManagerUpdated(notification:)),
                                               name: NSNotification.Name.BSLikesManagerUpdated,
                                               object: nil)
    }
    
    @objc func likesManagerUpdated(notification: Notification) {
        self.collectionView.likes = BSLikesManager.getLikes().mutableCopy() as? NSMutableArray
    }
}
