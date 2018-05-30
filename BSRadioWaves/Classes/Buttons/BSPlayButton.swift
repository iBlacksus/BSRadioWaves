// GNU General Public License v3.0
//
//  BSPlayButton.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/7/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSPlayButton: BSRoundButton {
    var isPlaying = false {
        didSet {
            self.icon?.isPlaying = self.isPlaying
        }
    }
    var isLoading = false {
        didSet {
            self.icon?.isLoading = self.isLoading
        }
    }
    var icon: BSPlayPauseIconView?
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        self.icon = BSPlayPauseIconView(frame: self.bounds)
        self.icon?.isUserInteractionEnabled = false
        self.addSubview(self.icon!)
    }
}
