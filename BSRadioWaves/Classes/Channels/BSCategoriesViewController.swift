// GNU General Public License v3.0
//
//  ViewController.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 10/31/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSCategoriesViewController: UIViewController {
    private var musicManager: BSMusicManagerProtocol?
    
    @IBOutlet var collectionView: BSCategoriesView!
    @IBOutlet var loadingView: BSWavesView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BSWatchConnectivityManager.shared.connect()
        
        self.loadingView.backgroundColor = UIColor.white
        self.loadingView.isActive = true
        
        let fabric = BSMusicManagerFabric()
        self.musicManager = fabric.manager(type: BSMusicManagerType.DI)
        BSFavoritesManager.shared.type = BSMusicManagerType.DI
        self.collectionView.musicManager = self.musicManager
        self.collectionView.viewController = self
        
        self.collectionView.update {
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.loading(enabled: false)
            }
        }
    }
    
    func loading(enabled: Bool) {
        if enabled {
            self.loadingView.isActive = true
            self.loadingView.isHidden = false
            self.loadingView.alpha = 1.0
        } else {
            UIView.animate(withDuration: 0.15, animations: {
                self.loadingView.alpha = 0.0
            }) { (completion) in
                self.loadingView.isActive = false
                self.loadingView.isHidden = true
            }
        }
    }
}

