// GNU General Public License v3.0
//
//  BSWatchConnectivityManager.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/21/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Foundation
import WatchConnectivity
import ObjectMapper

enum BSWatchConnectivityMessageField: String {
    case action = "action"
    case message = "message"
}

class BSWatchConnectivityManager: NSObject, WCSessionDelegate {
    private var session: WCSession!
    private var actionsManager: BSWatchConnectivityProtocol
    
    static let shared = BSWatchConnectivityManager()
    
    override init() {
        self.actionsManager = BSWatchConnectivityActions()
    }
    
    func connect() {
        if (WCSession.isSupported()) {
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    func sendMessage(action: BSWatchConnectivityAction, message: Mappable?) {
        if self.session == nil {
            self.connect()
            return
        }
        
        self.session.activate()
        
        var request = [BSWatchConnectivityMessageField: Any]()
        request[.action] = String(describing: action)
        if message != nil {
            request[.message] = message?.toJSON()
        }
        
        var adaptiveRequest = [String : Any]()
        for (index, item) in request {
            adaptiveRequest[String(describing: index)] = item
        }
        
        self.session.sendMessage(adaptiveRequest, replyHandler: nil, errorHandler: { (error) in
            print(error)
        })
    }
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
#if os(iOS)
    @available(iOS 9.3, *)
    func sessionDidBecomeInactive(_ session: WCSession) {
        self.session = nil
    }
    
    @available(iOS 9.3, *)
    func sessionDidDeactivate(_ session: WCSession) {
        self.session = nil
    }
#endif
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let actionString = message[String(describing: BSWatchConnectivityMessageField.action)]
        let action: BSWatchConnectivityAction = BSWatchConnectivityAction(rawValue: actionString as! String)!
        let data = message[String(describing: BSWatchConnectivityMessageField.message)]
        
        switch action {
        case .channelDidChange:
            self.actionsManager.channelDidChange(message: data as! [String : Any])
            break
        case .trackInfoDidChange:
            self.actionsManager.trackInfoDidChange(message: data as! [String : Any])
            break
        case .playingDidChange:
            self.actionsManager.playingDidChange(message: data as! [String : Any])
            break
        case .needUpdate:
            self.actionsManager.needUpdate(message: data as? [String : Any])
            break
        }
    }
        
}
