// GNU General Public License v3.0
//
//  BSWatchConnectivityResponseActionsWatchOS.swift
//  Watch Extension
//
//  Created by iBlacksus on 11/21/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit

class BSWatchConnectivityActions: BSWatchConnectivityProtocol {
    func channelDidChange(message: [String: Any]) {
        let object = BSMessageChannelDidChange(JSON: message)!
        NotificationCenter.default.post(name: Notification.Name.BSPlayerViewControllerChangeChannel, object: object)
    }
    
    func trackInfoDidChange(message: [String : Any]) {
        let object = BSMessageTrackInfoDidChange(JSON: message)!
        NotificationCenter.default.post(name: Notification.Name.BSPlayerViewControllerChangeTrackInfo, object: object)
    }
    
    func playingDidChange(message: [String : Any]) {
        let object = BSMessagePlayingDidChange(JSON: message)!
        NotificationCenter.default.post(name: Notification.Name.BSPlayerViewControllerChangePlaying, object: object)
    }
    
    func needUpdate(message: [String: Any]?) {
        let object = BSMessageNeedUpdate(JSON: message!)!
        NotificationCenter.default.post(name: Notification.Name.BSPlayerViewControllerNeedUpdate, object: object)
    }
}
