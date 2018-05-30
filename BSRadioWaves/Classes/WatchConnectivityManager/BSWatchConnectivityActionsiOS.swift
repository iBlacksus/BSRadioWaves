// GNU General Public License v3.0
//
//  BSWatchConnectivityResponseActionsiOS.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/21/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Foundation

class BSWatchConnectivityActions: BSWatchConnectivityProtocol {
    func channelDidChange(message: [String: Any]) {
        let object = BSMessageChannelDidChange(JSON: message)!
        let type: BSMusicManagerType? = BSMusicManagerType(rawValue: object.type!)
        var channel: BSChannel
        switch type {
        case .DI?:
            channel = BSDIChannel(JSONString: object.channel!)!
            break
        case .none:
            channel = BSChannel(JSONString: object.channel!)!
            break
        }
        
        DispatchQueue.main.async() {
            NotificationCenter.default.post(name: Notification.Name.BSTabBarControllerSelectTab, object: 1)
            NotificationCenter.default.post(name: Notification.Name.BSPlayerViewControllerChangeChannel, object: channel)
        }
    }
    
    func trackInfoDidChange(message: [String : Any]) {}
    
    func playingDidChange(message: [String : Any]) {
        let object = BSMessagePlayingDidChange(JSON: message)!
        NotificationCenter.default.post(name: Notification.Name.BSPlayerViewControllerChangePlaying, object: object)
    }
    
    func needUpdate(message: [String: Any]?) {
        NotificationCenter.default.post(name: Notification.Name.BSPlayerViewControllerNeedUpdate, object:nil)
    }
}
