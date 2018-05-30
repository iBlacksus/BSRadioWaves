// GNU General Public License v3.0
//
//  BSChannelsRow.swift
//  Watch
//
//  Created by iBlacksus on 11/20/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import WatchKit
import SDWebImage

class BSChannelRow: NSObject {
    var channel: BSChannel? {
        didSet {
            self.load()
        }
    }
    
//    @IBOutlet var image: WKInterfaceImage!
    @IBOutlet var label: WKInterfaceLabel!
    
    func load() {
        self.label.setText(self.channel?.name)
//        self.image.setImage(nil)
//
//        if self.channel?.image == nil {
//            return
//        }
//
//        let url = NSURL(string: "http:" + (self.channel?.image)!)! as URL
//        SDWebImageManager.shared().imageDownloader?.downloadTimeout = 120.0
//        SDWebImageManager.shared().imageDownloader?.setValue("User-agent", forHTTPHeaderField: "AudioAddict-di/4.0.5.5125 iOS/11.0.3")
//        SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.retryFailed, progress: nil) { (image, data, error, type, finished, url) in
//            if image != nil {
//                self.image.setImage(image)
//            }
//        }
    }
}
