// GNU General Public License v3.0
//
//  BSPlayerNotificationsHelper.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/28/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit
import MediaPlayer
import Alamofire

class BSPlayerNotificationsHelper: NSObject {
    var controller: BSPlayerViewController
    
    init(controller: BSPlayerViewController) {
        self.controller = controller
    }
    
    func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(notification:)), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeChannel(notification:)), name: .BSPlayerViewControllerChangeChannel, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changePlaying(notification:)), name: .BSPlayerViewControllerChangePlaying, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.needUpdate(notification:)), name: .BSPlayerViewControllerNeedUpdate, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidBecomeActive(notification:)), name: .UIApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioSessionInterruption(notification:)), name: .AVAudioSessionInterruption, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioSessionRouteChange(notification:)), name: .AVAudioSessionRouteChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioSessionMediaServicesWereLost(notification:)), name: .AVAudioSessionMediaServicesWereLost, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioSessionMediaServicesWereReset(notification:)), name: .AVAudioSessionMediaServicesWereReset, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioSessionSilenceSecondaryAudioHint(notification:)), name: .AVAudioSessionSilenceSecondaryAudioHint, object: nil)
    }
    
    @objc func playerDidFinishPlaying(notification: Notification) {
        DispatchQueue.main.async {
            self.controller.nextTrack()
        }
    }
    
    @objc func playerFailedToPlay(notification: Notification) {
        DispatchQueue.main.async {
            self.controller.playTrack(play: false)
        }
    }
    
    @objc func changeChannel(notification: Notification) {
        let channel = notification.object as! BSChannel
        DispatchQueue.main.async {
            self.controller.channel = channel
            self.controller.update(autoplay: true)
        }
    }
    
    @objc func changePlaying(notification: Notification) {
        let object = notification.object as! BSMessagePlayingDidChange
        let isPlaying = object.isPlaying
        DispatchQueue.main.async {
            self.controller.playTrack(play: isPlaying)
        }
    }
    
    @objc func needUpdate(notification: Notification) {
        if self.controller.channel == nil {
            return
        }
        
        var messageTrack: BSMessageTrackInfoDidChange?
        let messageChannel = BSMessageChannelDidChange(channel: self.controller.channel!, type: .DI)
        let messagePlaying = BSMessagePlayingDidChange(isPlaying: self.controller.isPlaying)
        
        if self.controller.audioPlayer?.status == AVPlayerStatus.readyToPlay {
            let track = self.controller.tracks[self.controller.trackIndex] as! BSTrack
            let duration = CMTimeGetSeconds((self.controller.audioPlayer?.currentItem!.duration)!)
            let time = CMTimeGetSeconds((self.controller.audioPlayer?.currentTime())!)
            messageTrack = BSMessageTrackInfoDidChange(track: track, type: .DI, playbackTime: time, duration: duration)
        }
        
        let message = BSMessageNeedUpdate(messageChannel: messageChannel, messageTrackInfo: messageTrack, messagePlaying: messagePlaying)
        BSWatchConnectivityManager.shared.sendMessage(action: .needUpdate, message: message)
    }
    
    @objc func appDidBecomeActive(notification: Notification) {
        self.controller.updateStatus()
    }
    
    @objc func audioSessionInterruption(notification: Notification) {
        DispatchQueue.main.async {
            self.controller.playTrack(play: false)
        }
    }
    
    @objc func audioSessionRouteChange(notification: Notification) {
        print("audioSessionRouteChange")
    }
    
    @objc func audioSessionSilenceSecondaryAudioHint(notification: Notification) {
        DispatchQueue.main.async {
            self.controller.playTrack(play: false)
        }
    }
    
    @objc func audioSessionMediaServicesWereLost(notification: Notification) {
        DispatchQueue.main.async {
            self.controller.playTrack(play: false)
        }
    }
    
    @objc func audioSessionMediaServicesWereReset(notification: Notification) {
        DispatchQueue.main.async {
            self.controller.playTrack(play: false)
        }
    }
}
