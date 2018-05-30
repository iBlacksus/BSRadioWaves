// GNU General Public License v3.0
//
//  BSRoundView.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/8/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSRoundView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
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
