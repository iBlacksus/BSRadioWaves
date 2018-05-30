// GNU General Public License v3.0
//
//  BSPlayView.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/7/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSPlayPauseIconView: UIView {
    var waves: BSWavesView?
    
    var isPlaying = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var isLoading = true {
        didSet {
            self.waves?.isActive = self.isLoading
            self.waves?.isHidden = !self.isLoading
            self.setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        self.initialization()
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.initialization()
    }
    
    func initialization() {
        self.backgroundColor = UIColor.clear
        
        self.waves = BSWavesView(frame: self.bounds)
        self.waves?.color = UIColor.white
        self.waves?.isUserInteractionEnabled = false
        self.waves?.isActive = false
        self.waves?.isHidden = true
        self.addSubview(self.waves!)
    }
    
    override func draw(_ rect: CGRect) {
        super .draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        if self.isLoading {
            return
        }
        
        let offsetX: CGFloat = self.bounds.width * 0.15
        let offsetY: CGFloat = self.bounds.height * 0.15
        let frame = CGRect(x: self.bounds.minX + offsetX, y: self.bounds.minY + offsetY, width: self.bounds.width - offsetX * 2, height: self.bounds.height - offsetY * 2)
        
        if self.isPlaying {
            drawPause(context: context!, rect: frame)
        } else {
            drawPlay(context: context!, rect: frame)
        }
    }
    
    func drawPlay(context: CGContext, rect: CGRect) {
        let offsetX: CGFloat = rect.width / 8
        
        context.setFillColor(UIColor.white.cgColor)
        context.move(to: CGPoint(x: rect.minX + rect.width / 4 + offsetX, y: rect.minY + rect.height / 4))
        context.addLine(to: CGPoint(x: rect.minX + rect.width * 2.5 / 4 + offsetX, y: rect.midY))
        context.addLine(to: CGPoint(x: rect.minX + rect.width / 4 + offsetX, y: rect.minY + rect.height * 3 / 4))
        context.addLine(to: CGPoint(x: rect.minX + rect.width / 4 + offsetX, y: rect.minY + rect.height / 4))
        context.fillPath()
    }
    
    func drawPause(context: CGContext, rect: CGRect) {
        context.setFillColor(UIColor.white.cgColor)
        context.move(to: CGPoint(x: rect.minX + rect.width / 4, y: rect.minY + rect.height / 4))
        context.addLine(to: CGPoint(x: rect.minX + rect.width / 4, y: rect.minY + rect.height * 3 / 4))
        context.addLine(to: CGPoint(x: rect.minX + rect.width * 2 / 5, y: rect.minY + rect.height * 3 / 4))
        context.addLine(to: CGPoint(x: rect.minX + rect.width * 2 / 5, y: rect.minY + rect.height / 4))
        context.addLine(to: CGPoint(x: rect.minX + rect.width / 4, y: rect.minY + rect.height / 4))
        context.fillPath()
        
        context.move(to: CGPoint(x: rect.minX + rect.width * 3 / 4, y: rect.minY + rect.height / 4))
        context.addLine(to: CGPoint(x: rect.minX + rect.width * 3 / 4, y: rect.minY + rect.height * 3 / 4))
        context.addLine(to: CGPoint(x: rect.minX + rect.width * 3 / 5, y: rect.minY + rect.height * 3 / 4))
        context.addLine(to: CGPoint(x: rect.minX + rect.width * 3 / 5, y: rect.minY + rect.height / 4))
        context.addLine(to: CGPoint(x: rect.minX + rect.width * 3 / 4, y: rect.minY + rect.height / 4))
        context.fillPath()
    }
}
