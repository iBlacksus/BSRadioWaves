// GNU General Public License v3.0
//
//  BSAnimation.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/15/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

extension NSObject {
    func animateImageTap(imageView: UIImageView, parentView: UIView) {
        let frame = imageView.frame
        let image = UIImageView(frame: frame)
        image.image = imageView.image
        parentView.addSubview(image)
        UIView.animate(withDuration: 0.25, animations: {
            image.frame = CGRect(x: frame.minX - 20, y: frame.minY - 20, width: frame.width + 40, height: frame.height + 40)
            image.alpha = 0
        }) { (completion) in
            image.removeFromSuperview()
        }
    }
}
