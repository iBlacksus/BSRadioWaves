//// GNU General Public License v3.0
//
//  BSRoundButton.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/7/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSRoundButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        
        if self.layer.sublayers != nil {
            for layer in self.layer.sublayers! {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        let background = CAGradientLayer().backgroundGradientColor()
        background.frame = self.bounds
        self.layer.insertSublayer(background, at: 0)
    }
}
