// GNU General Public License v3.0
//
//  BSPagesManager.swift
//  Watch Extension
//
//  Created by iBlacksus on 11/22/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Foundation

enum BSPagesManagerPage {
    case channels
    case player
    case likes
}

extension NSNotification.Name {
    public static let BSPagesManagerOpenChannels: NSNotification.Name = NSNotification.Name(rawValue: "BSPagesManagerOpenChannels")
    public static let BSPagesManagerOpenPlayer: NSNotification.Name = NSNotification.Name(rawValue: "BSPagesManagerOpenPlayer")
    public static let BSPagesManagerOpenLikes: NSNotification.Name = NSNotification.Name(rawValue: "BSPagesManagerOpenLikes")
}

class BSPagesManager: NSObject {
    static func openPage(page: BSPagesManagerPage, object: Any?) {
        let notification = self.notificationForPage(page: page)
        NotificationCenter.default.post(name: notification, object: object)
    }
    
    static func notificationForPage(page: BSPagesManagerPage) -> NSNotification.Name {
        switch page {
        case .channels:
            return NSNotification.Name.BSPagesManagerOpenChannels
        case .player:
            return NSNotification.Name.BSPagesManagerOpenPlayer
        case .likes:
            return NSNotification.Name.BSPagesManagerOpenLikes
        }
    }
}
