// GNU General Public License v3.0
//
//  BSTrackInfoView.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/14/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit
import SDWebImage

typealias BSTrackInfoViewTrackImageLoadingCompleted = () -> Void

class BSTrackInfoView: BSRoundView {
    var trackImageLoadingCompleted: BSTrackInfoViewTrackImageLoadingCompleted?
    
    var channel: BSChannel? {
        didSet {
            self.updateChannelInfo()
        }
    }
    var track: BSTrack? {
        didSet {
            self.updateTrackInfo()
        }
    }
    var trackImage: UIImage?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var trackImageView: UIImageView!
    @IBOutlet var trackImageBackgroundView: BSCircleView!
    @IBOutlet var channelNameLabel: UILabel!
    
    override func awakeFromNib() {
        super .awakeFromNib()
        
        self.titleLabel.text = nil
        self.artistLabel.text = nil
        self.trackImageBackgroundView.isHidden = true
    }
    
    func updateTrackInfo() {
        self.titleLabel.text = self.track?.title
        self.artistLabel.text = self.track?.artist
        self.trackImage = nil
        if self.track?.image == nil {
            self.trackImageView.image = nil
            self.trackImageBackgroundView.isHidden = true
        } else {
            self.trackImageView.sd_setImage(with: URL(string: "http:" + (self.track?.image)!), completed: { (image, error, cacheType, url) in
                self.trackImageBackgroundView.isHidden = image == nil
                if image != nil {
                    self.trackImage = image
                    self.trackImageLoadingCompleted!()
                }
            })
        }
    }
    
    func updateChannelInfo() {
        self.channelNameLabel.text = self.channel?.name
        self.fillFontSize(label: self.channelNameLabel)
    }
    
    func fillFontSize(label: UILabel) {
        if (label.text?.count)! < 1 {
            return
        }
        
        var width: CGFloat = 0.0
        var size: CGFloat = 10
        while CGFloat(width) < label.bounds.width {
            let font = UIFont(name: label.font.fontName, size: size)
            let fontAttributes = [NSAttributedStringKey.font: font!]
            width = (label.text?.size(withAttributes: fontAttributes).width)!
            size += 1
        }
        
        label.font = UIFont.systemFont(ofSize: size - 1)
    }
    
}
