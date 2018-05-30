// GNU General Public License v3.0
//
//  BSURLConstants.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/1/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Alamofire

struct BSDIAppUrl {
    static let domain = "https://api.audioaddict.com"
    static let apiRoute = "/v1/di"
    static let mobileRoute = "/mobile"
    static let routinesRoute = "/routines"
    static let baseURL = domain + apiRoute
    static let batchUpdateURL = baseURL + mobileRoute + "/batch_update?stream_set_key=appleapp"
    static let channelURL = baseURL + routinesRoute + "/channel/%d?api_key=" + apiKey
    static let apiKey = ""
    
    static let headers: HTTPHeaders = [
        "Authorization": "Basic bW9iaWxlOmFwcHM=",
        "Accept": "application/json",
        "User-agent": "AudioAddict-di/4.1.0.5213 iOS/11.1.2"
    ]
}
