// GNU General Public License v3.0
//
//  BSShareButton.swift
//  BSRadioWaves
//
//  Created by Oleg Musinov on 11/9/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSLikeButton: BSRoundButton {
    override func draw(_ rect: CGRect) {
        super .draw(rect)
        
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = 1.0
        bezierPath.move(to: CGPoint(x: 50, y: 100))
        bezierPath.addLine(to: CGPoint(x: 43, y: 92.39))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 29.89), controlPoint1: CGPoint(x: 17, y: 67.39), controlPoint2: CGPoint(x: 0, y: 50.54))
        bezierPath.addCurve(to: CGPoint(x: 27.5, y: 0), controlPoint1: CGPoint(x: 0, y: 13.04), controlPoint2: CGPoint(x: 12, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 50, y: 11.41), controlPoint1: CGPoint(x: 36, y: 0), controlPoint2: CGPoint(x: 44.5, y: 4.35))
        bezierPath.addCurve(to: CGPoint(x: 72.5, y: 0), controlPoint1: CGPoint(x: 55.5, y: 4.35), controlPoint2: CGPoint(x: 64, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 100, y: 29.89), controlPoint1: CGPoint(x: 88, y: 0), controlPoint2: CGPoint(x: 100, y: 13.04))
        bezierPath.addCurve(to: CGPoint(x: 57, y: 92.39), controlPoint1: CGPoint(x: 100, y: 50.54), controlPoint2: CGPoint(x: 83, y: 67.39))
        bezierPath.addLine(to: CGPoint(x: 50, y: 100))
        bezierPath.close()
        
        let scale = CGAffineTransform(scaleX: 40.0/100.0, y: 40.0/100.0)
        bezierPath.apply(scale)
        
        UIColor.blue.setFill()
        UIColor.white.setStroke()
        bezierPath.fill()
        bezierPath.stroke()
    }
}
