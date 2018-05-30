// GNU General Public License v3.0
//
//  BSCircleView.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/8/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSCircleView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }
}
