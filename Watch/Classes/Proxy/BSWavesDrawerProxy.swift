// GNU General Public License v3.0
//
//  BSLoadingImage.swift
//  Watch Extension
//
//  Created by iBlacksus on 11/22/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import WatchKit

class BSWavesDrawerProxy: NSObject {
    var drawer: BSWavesDrawer?
    var color: UIColor? {
        didSet {
            self.drawer?.color = self.color
        }
    }
    var isActive = true {
        didSet {
            self.drawer?.isActive = self.isActive
            self.draw()
        }
    }
    
    private var image: WKInterfaceImage?
    private var group: WKInterfaceGroup?
    
    init(image: WKInterfaceImage) {
        super.init()
        
        self.image = image
        self.initialization()
    }
    
    init(group: WKInterfaceGroup) {
        super.init()
        
        self.group = group
        self.initialization()
    }
    
    func initialization() {
        self.drawer = BSWavesDrawer()
        self.drawer?.redrawHandler = { () -> Void in
            self.draw()
        }
    }
    
    func draw() {
        let rect = WKInterfaceDevice.current().screenBounds
        let size = rect.size

        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        self.drawer?.drawNextAnimation(context: context!, rect: rect)
        let cgImage = context?.makeImage()
        let uiImage = UIImage(cgImage: cgImage!)
        UIGraphicsEndImageContext()

        if self.image != nil {
            self.image?.setImage(uiImage)
        } else if self.group != nil {
            self.group?.setBackgroundImage(uiImage)
        }
    }
}
