// GNU General Public License v3.0
//
//  BSPlayerNetworkHelper.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/28/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift

class BSPlayerNetworkHelper: NSObject {
    var controller: BSPlayerViewController
    let reachabilityManager: NetworkReachabilityManager
    
    init(controller: BSPlayerViewController) {
        self.controller = controller
        self.reachabilityManager = NetworkReachabilityManager()!
    }
    
    func startNetworkReachabilityObserver() {
        self.reachabilityManager.listener = { status in
            switch status {
                
            case .notReachable:
                self.controller.playTrack(play: false)
                self.controller.view.makeToast("The network is not reachable", duration: 1.25, position: .top)
                break
                
            default:
                self.controller.view.makeToast("The network is reachable", duration: 1.25, position: .top)
                self.controller.updateStatus()
                self.controller.checkTrackLoadingStatus()
            }
        }
        
        self.reachabilityManager.startListening()
    }
}
