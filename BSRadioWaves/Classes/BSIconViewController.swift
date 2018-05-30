// GNU General Public License v3.0
//
//  BSIconViewController.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/15/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSIconViewController: UIViewController {
    @IBOutlet var wavesView: BSWavesView!
    @IBOutlet var iconView: BSPlayPauseIconView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.iconView.isPlaying = false
        self.iconView.isLoading = false
        self.wavesView.isActive = false
        self.wavesView.configurePanGesture()
        self.wavesView.color = UIColor.white
    }
}
