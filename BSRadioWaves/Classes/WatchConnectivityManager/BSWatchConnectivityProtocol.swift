// GNU General Public License v3.0
//
//  BSWatchConnectivityProtocol.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/21/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

#if os(watchOS)
import WatchKit
#else
import Foundation
#endif
import ObjectMapper

enum BSWatchConnectivityAction: String {
    case channelDidChange = "channelDidChange"
    case trackInfoDidChange = "trackInfoDidChange"
    case playingDidChange = "playingDidChange"
    case needUpdate = "needUpdate"
}

protocol BSWatchConnectivityProtocol {
    func channelDidChange(message: [String: Any])
    func trackInfoDidChange(message: [String: Any])
    func playingDidChange(message: [String: Any])
    func needUpdate(message: [String: Any]?)
}

class BSMessageChannelDidChange: Mappable {
    var channel: String?
    var type: String?
    
    required init?(map: Map){}
    init(channel: BSChannel, type: BSMusicManagerType) {
        self.channel = channel.toJSONString()!
        self.type = String(describing: type)
    }
    
    func mapping(map: Map) {
        channel <- map["channel"]
        type <- map["type"]
    }
}

class BSMessageTrackInfoDidChange: Mappable {
    var track: String?
    var type: String?
    var playbackTime: Float64 = 0.0
    var duration: Float64 = 0.0
    
    required init?(map: Map){}
    init(track: BSTrack, type: BSMusicManagerType, playbackTime: Float64, duration: Float64) {
        self.track = track.toJSONString()
        self.type = String(describing: type)
        self.playbackTime = playbackTime
        self.duration = duration
    }
    
    func mapping(map: Map) {
        track <- map["track"]
        type <- map["type"]
        playbackTime <- map["playbackTime"]
        duration <- map["duration"]
    }
}

class BSMessagePlayingDidChange: Mappable {
    var isPlaying: Bool = false
    
    required init?(map: Map){}
    init(isPlaying: Bool) {
        self.isPlaying = isPlaying
    }
    
    func mapping(map: Map) {
        isPlaying <- map["isPlaying"]
    }
}

class BSMessageNeedUpdate: Mappable {
    var messageChannel: BSMessageChannelDidChange?
    var messageTrackInfo: BSMessageTrackInfoDidChange?
    var messagePlaying: BSMessagePlayingDidChange?
    
    required init?(map: Map){}
    init(messageChannel: BSMessageChannelDidChange?, messageTrackInfo: BSMessageTrackInfoDidChange?, messagePlaying: BSMessagePlayingDidChange?) {
        self.messageChannel = messageChannel
        self.messageTrackInfo = messageTrackInfo
        self.messagePlaying = messagePlaying
    }
    
    func mapping(map: Map) {
        messageChannel <- map["messageChannel"]
        messageTrackInfo <- map["messageTrackInfo"]
        messagePlaying <- map["messagePlaying"]
    }
}
