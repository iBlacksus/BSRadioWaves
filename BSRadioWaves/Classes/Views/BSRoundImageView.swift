// GNU General Public License v3.0
//
//  BSRoundImageView.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/8/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSRoundImageView: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 0.5 * self.bounds.width
    }
}
