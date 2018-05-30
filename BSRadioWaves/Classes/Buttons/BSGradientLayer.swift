// GNU General Public License v3.0
//
//  BSGradientLayer.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/7/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func backgroundGradientColor() -> CAGradientLayer {
        let topColor = UIColor(red: (255.0/255.0), green: (159.0/255.0), blue:(126.0/255.0), alpha: 1.0)
        let bottomColor = UIColor(red: (254.0/255.0), green: (62.0/255.0), blue:(103.0/255.0), alpha: 1.0)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        return gradientLayer
    }
}
