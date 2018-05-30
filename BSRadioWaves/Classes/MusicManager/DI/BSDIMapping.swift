// GNU General Public License v3.0
//
//  BSDIMapping.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/1/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Foundation
import ObjectMapper

class BSDIBatchUpdateResponse: Mappable {
    var channelFilters: [BSDIChannelFilter]?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        channelFilters <- map["channel_filters"]
    }
}

class BSDIChannelFilter: BSCategory {
    var diChannels: [BSDIChannel]?
    override var channels: [BSChannel]? {
        get {
            return diChannels
        }
        set {}
    }
    
    override func mapping(map: Map) {
        name <- map["name"]
        diChannels <- map["channels"]
    }
}

class BSDIChannel: BSChannel {
    override func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        image <- map["asset_url"]
    }
}

class BSDIChannelResponse: Mappable {
    var tracks: [BSDITrack]?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        tracks <- map["tracks"]
    }
}

class BSDITrackAsset: Mappable {
    var url: String?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        url <- map["url"]
    }
}

class BSDITrack: BSTrack {
    override func mapping(map: Map) {
        artist <- map["display_artist"]
        title <- map["display_title"]
        lenght <- map["length"]
        waveform <- map["waveform_url"]
        url <- map["content.assets.0.url"]
        image <- map["asset_url"]
    }
}
