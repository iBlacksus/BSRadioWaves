// GNU General Public License v3.0
//
//  BSWaveformView.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/8/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSWaveformView: UIView {
    var url: String? {
        didSet {
            self.load()
        }
    }
    
    private var musicManager: BSMusicManagerProtocol?
    private var waveform: NSArray = []
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
    }
    
    func load() {
        let fabric = BSMusicManagerFabric()
        self.musicManager = fabric.manager(type: BSMusicManagerType.DI)
        
        self.musicManager?.getWaveform(url: URL(string: "http:" + self.url!)!, completion: { (waveform) in
            self.avgWaveform(waveform: waveform)
        })
    }
    
    func avgWaveform(waveform: NSArray) {
        let chunksCount = 100
        let wavesInChunk = waveform.count / chunksCount
        let newWavesInChunk = waveform.count / chunksCount
        let avg = NSMutableArray()
        avg.add(0.0)
        var maxWave = 0.0
        var avgWave = 0.0
        var prevAvgWave = 0.0
        var index = 0
        for line in waveform {
            if index >= wavesInChunk {
                var avgIndex = 0
                avgWave /= Double(wavesInChunk)
                maxWave = max(maxWave, avgWave)
                let avgFactor = (avgWave - prevAvgWave) / Double(newWavesInChunk)
                while avgIndex < newWavesInChunk {
                    avg.add(prevAvgWave + avgFactor * Double(avgIndex))
                    avgIndex += 1
                }
                
                index = 0
                prevAvgWave = avgWave
                avgWave = 0.0
            }
            
            avgWave += line as! Double
            index += 1
        }
        
        avg.add(0.0)
        
        index = 0
        var factor = (1.0 - maxWave)
        if factor > 0.3 {
            factor = 0.3
        }
        while index < avg.count {
            let wave = (avg[index] as! NSNumber).floatValue
            if wave > 0.0 {
                avg[index] = wave + Float(factor)
            }
            index += 1
        }
        
        self.waveform = avg
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super .draw(rect)
        
        if waveform.count == 0 {
            return
        }
        
        let fillColor = UIColor.red
        fillColor.setFill()
        let strokeColor = UIColor.white
        strokeColor.setStroke()
        
        let path = UIBezierPath()
        let originalPath = self.pathForWaveform(rect: rect, reverse: false)
        let reversePath = self.pathForWaveform(rect: rect, reverse: true)
        path.append(originalPath)
        path.append(reversePath)
        
        path.close()
        
        let shape = CAShapeLayer()
        shape.frame = rect
        shape.path = path.cgPath;
        shape.strokeColor = UIColor.clear.cgColor
        shape.lineWidth = 1
        shape.fillColor = nil
        
        let background = CAGradientLayer().backgroundGradientColor()
        background.frame = rect
        
        let mask = CAShapeLayer()
        mask.frame = rect
        mask.path = path.cgPath
        background.mask = mask
        
        if self.layer.sublayers != nil {
            for layer in self.layer.sublayers! {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        self.layer.addSublayer(background)
        self.layer.addSublayer(shape)
    }
    
    func pathForWaveform(rect: CGRect, reverse: Bool) -> UIBezierPath {
        var x: CGFloat = reverse ? rect.width : 0.0
        let xAddition = rect.width / CGFloat(self.waveform.count)
        let path = UIBezierPath()
        path.move(to: CGPoint(x:x, y:rect.height / 2))
        var i = 0
        while i < self.waveform.count {
            let index = reverse ? self.waveform.count - 1 - i : i
            let line = self.waveform[index]
            var y = (line as! CGFloat) * (rect.height / 2)
            y = reverse ? rect.height / 2 - y : rect.height / 2 + y
            path.addLine(to: CGPoint(x: x, y: y))
            x += reverse ? -xAddition : xAddition
            i += 1
        }
        
        return path
    }
}
