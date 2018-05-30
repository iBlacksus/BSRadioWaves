// GNU General Public License v3.0
//
//  BSWavesDrawer.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/22/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

#if os(watchOS)
    import WatchKit
#else
    import UIKit
#endif

typealias BSWavesDrawerRedrawHandler = () -> Void

class BSWavesDrawer: NSObject {
    var redrawHandler: BSWavesDrawerRedrawHandler?
    var color: UIColor?
    var isActive = true {
        didSet {
            if self.isActive {
                if self.waveOffsets.count == 0 {
                    self.generateWaveOffsets()
                }
            }
        }
    }
    private var updateTimer: Timer?
    
    private var waveOffsets: NSMutableArray = []
    private var waveOffsetSpeeds: NSMutableArray = []
    private let minLoadingSpeed = 0.2
    private let maxLoadingSpeed = 0.6
    private let waveSpeedsCount = 3
    
    private let topR = 255.0
    private let topG = 159.0
    private let topB = 126.0
    private let bottomR = 254.0
    private let bottomG = 62.0
    private let bottomB = 103.0
    
    override init() {
        super.init()
        
        self.initialization()
    }
    
    func initialization() {
        self.generateWaveOffsets()
    }
    
    @objc func nextLoadingAnimationFrame() {
        if self.redrawHandler != nil {
            self.redrawHandler!()
        }
    }
    
    func resetWaveOffsets() {
        self.waveOffsets = NSMutableArray.init(array: [])
        self.waveOffsetSpeeds = NSMutableArray.init(array: [])
    }
    
    func generateWaveOffsets() {
        self.resetWaveOffsets()
        var i = 0
        while i < self.waveSpeedsCount {
            var speed = Float(Float(arc4random()) / Float(UINT32_MAX))
            speed = max(speed, Float(self.minLoadingSpeed))
            speed = min(speed, Float(self.maxLoadingSpeed))
            for s in self.waveOffsetSpeeds {
                let factor = abs(speed - (s as! Float))
                if factor < 0.1 {
                    speed += 0.1
                }
            }
            self.waveOffsetSpeeds[i] = speed
            self.waveOffsets[i] = 0.0
            i += 1
        }
    }
    
    func startTimer(start: Bool) {
        DispatchQueue.main.async {
            if self.updateTimer != nil {
                self.updateTimer?.invalidate()
                self.updateTimer = nil
            }
            
            if !start {
                return
            }
            
            self.updateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.nextLoadingAnimationFrame), userInfo: nil, repeats: false)
        }
    }
    
    func drawNextAnimation(context: CGContext, rect: CGRect) {
        var i = 0
        while i < self.waveOffsets.count {
            self.drawWaves(context: context, rect: rect, offset: self.waveOffsets[i] as! Float, index: i)
            if self.isActive {
                self.updateWaveOffset(index: i)
            }
            i += 1
        }
        
        if !self.isActive {
            return
        }
        
        self.startTimer(start: true)
        
//        let deadlineTime = DispatchTime.now() + .milliseconds(100)
//        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
//            self.nextLoadingAnimationFrame()
//        }
    }
    
    func updateWaveOffset(index: Int, reverse: Bool = false, speedFactor: Float = 1.0) {
        let offset: Float = self.waveOffsets[index] as! Float
        let speed: Float = self.waveOffsetSpeeds[index] as! Float * speedFactor
        var newOffset = reverse ? offset - speed : offset + speed
        if newOffset > 270 {
            newOffset -= 270
        } else if newOffset < 0 {
            newOffset += 270
        }
        self.waveOffsets[index] = newOffset
    }
    
    func drawWaves(context: CGContext, rect: CGRect, offset: Float, index: Int) {
        let graphWidth: CGFloat = 1.0
        let amplitude: CGFloat = 0.2
        
        let origin = CGPoint(x: rect.width * (1 - graphWidth) / 2, y: rect.height * 0.50)
        
        let path = UIBezierPath()
        path.move(to: origin)
        
        for angle in stride(from: 0.0, through: 360.0, by: 5.0) {
            let x = origin.x + CGFloat(angle/360.0) * rect.width * graphWidth
            let y = origin.y - CGFloat(sin(angle/180.0 * Double.pi + Double(offset))) * rect.height * amplitude
            let point = CGPoint(x: x, y: y)
            if angle == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        if self.color == nil {
            let color = self.generateColor(index: index)
            color.setStroke()
        } else {
            self.color?.setStroke()
        }
        
        context.addPath(path.cgPath)
        context.drawPath(using: .stroke)
    }
    
    func generateColor(offset: Float) -> UIColor {
        let r = self.bottomR + (self.topR - self.bottomR) / 360.0 * Double(offset)
        let g = self.bottomG + (self.topG - self.bottomG) / 360.0 * Double(offset)
        let b = self.bottomB + (self.topB - self.bottomB) / 360.0 * Double(offset)
        
        return UIColor(red: (CGFloat(r/255.0)), green: (CGFloat(g/255.0)), blue:(CGFloat(b/255.0)), alpha: 1.0)
    }
    
    func generateColor(index: Int) -> UIColor {
        let r = bottomR + (self.topR - self.bottomR) / Double(waveSpeedsCount - 1) * Double(index)
        let g = bottomG + (self.topG - self.bottomG) / Double(waveSpeedsCount - 1) * Double(index)
        let b = bottomB + (self.topB - self.bottomB) / Double(waveSpeedsCount - 1) * Double(index)
        
        return UIColor(red: (CGFloat(r/255.0)), green: (CGFloat(g/255.0)), blue:(CGFloat(b/255.0)), alpha: 1.0)
    }
}
