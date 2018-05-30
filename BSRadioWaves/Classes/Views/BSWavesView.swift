// GNU General Public License v3.0
//
//  BSWavesView.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/8/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSWavesView: UIView {
    var color: UIColor? {
        didSet {
            self.drawer.color = self.color
        }
    }
    var isActive = true {
        didSet {
            self.panGesture?.isEnabled = !self.isActive
            self.drawer.isActive = self.isActive
            self.setNeedsDisplay()
        }
    }
    
    private var drawer: BSWavesDrawer!
    private var panGesture: UIPanGestureRecognizer?
    private var prevX: CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        self.initialization()
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.initialization()
    }
    
    func initialization() {
        self.drawer = BSWavesDrawer()
        self.drawer.redrawHandler = { () -> Void in
            self.setNeedsDisplay()
        }
        self.backgroundColor = UIColor.clear
    }
    
    func configurePanGesture() {
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.moveWaves(gesture:)))
        self.panGesture?.isEnabled = true
        self.addGestureRecognizer(self.panGesture!)
    }
    
    override func draw(_ rect: CGRect) {
        super .draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        self.drawer.drawNextAnimation(context: context!, rect: rect)
    }
    
    
    
    @objc func moveWaves(gesture: UIPanGestureRecognizer) {
//        if gesture.state != .began && gesture.state != .changed {
//            return
//        }
//
//        if self.isActive {
//            return
//        }
//
//        let translation = gesture.translation(in: self)
//
//        if gesture.state == .began {
//            self.prevX = translation.x
//            return
//        }
//
//        let x = translation.x - self.prevX
//
//        var i = 0
//        while i < self.waveOffsets.count {
//            self.updateWaveOffset(index: i, reverse: x > 0, speedFactor: Float(abs(x) / 35.0))
//            i += 1
//        }
//        self.setNeedsDisplay()
//
//        self.prevX = translation.x
    }
}
