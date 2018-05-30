// GNU General Public License v3.0
//
//  BSTabBarController.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/7/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    public static let BSTabBarControllerSelectTab: NSNotification.Name = NSNotification.Name(rawValue: "BSTabBarControllerSelectTab")
}

class BSTabBarController: UITabBarController {
    override func viewDidLoad() {
        super .viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.selectTab(notification:)), name: NSNotification.Name.BSTabBarControllerSelectTab, object: nil)
        
        self.selectedIndex = 0
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        let attributes = [NSAttributedStringKey.font: UIFont(name: "Roboto-Light", size: 12.0) as Any]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: UIControlState.normal)
    }
    
    @objc func selectTab(notification: Notification) {
        let index = notification.object as! NSNumber
        self.selectedIndex = index.intValue
        
        let item = self.tabBar.items![self.selectedIndex]
        item.isEnabled = true
    }
}
