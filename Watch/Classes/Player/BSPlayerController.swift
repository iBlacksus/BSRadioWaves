// GNU General Public License v3.0
//
//  BSPlayerController.swift
//  Watch Extension
//
//  Created by iBlacksus on 11/20/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import WatchKit
import ObjectMapper

extension NSNotification.Name {
    public static let BSPlayerViewControllerChangeTrackInfo: NSNotification.Name = NSNotification.Name(rawValue: "BSPlayerViewControllerChangeTrackInfo")
    public static let BSPlayerViewControllerChangePlaying: NSNotification.Name = NSNotification.Name(rawValue: "BSPlayerViewControllerChangePlaying")
    public static let BSPlayerViewControllerChangeChannel: NSNotification.Name = NSNotification.Name(rawValue: "BSPlayerViewControllerChangeChannel")
    public static let BSPlayerViewControllerNeedUpdate: NSNotification.Name = NSNotification.Name(rawValue: "BSPlayerViewControllerNeedUpdate")
}

class BSPlayerController: WKInterfaceController {
    @IBOutlet var mainGroup: WKInterfaceGroup!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var artistLabel: WKInterfaceLabel!
    @IBOutlet var trackPositionLabel: WKInterfaceLabel!
    @IBOutlet var trackDurationLabel: WKInterfaceLabel!
    @IBOutlet var trackTimeGroup: WKInterfaceGroup!
    @IBOutlet var playButton: WKInterfaceButton!
    @IBOutlet var loadingImage: WKInterfaceImage!
    
    private var track: BSTrack?
    private var playbackTime: Float64 = 0.0
    private var duration: Float64 = 0.0
    private var isLoading = false {
        didSet {
            self.update()
        }
    }
    private var isPlaying = false {
        didSet {
            self.update()
        }
    }
    private var loadingImageDrawer: BSWavesDrawerProxy?
    private var fullScreenLoadingImageDrawer: BSWavesDrawerProxy?
    private var channel: BSChannel? {
        didSet {
            self.isLoading = true
        }
    }
    private var trackUpdateTimer: Timer?
    private var needUpdate = false
    private var appActive = true
    private var needUpdateTimer: Timer?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.titleLabel.setText(nil)
        self.artistLabel.setText(nil)
        self.trackPositionLabel.setText(nil)
        self.trackDurationLabel.setText(nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openPage(notification:)), name: .BSPagesManagerOpenPlayer, object: nil)
        
        self.loadingImageDrawer = BSWavesDrawerProxy(group: self.trackTimeGroup)
        self.fullScreenLoadingImageDrawer = BSWavesDrawerProxy(image: self.loadingImage)
        self.fullScreenLoadingImageDrawer?.color = UIColor.white
        
        self.subscribeNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive(notification:)), name: .BSApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notification:)), name: .BSApplicationWillResignActive, object: nil)
    }
    
    func subscribeNotifications() {
        self.unsubscribeNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeTrackInfo(notification:)), name: .BSPlayerViewControllerChangeTrackInfo, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changePlaying(notification:)), name: .BSPlayerViewControllerChangePlaying, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeChannel(notification:)), name: .BSPlayerViewControllerChangeChannel, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.needUpdate(notification:)), name: .BSPlayerViewControllerNeedUpdate, object: nil)
    }
    
    func unsubscribeNotifications() {
        NotificationCenter.default.removeObserver(self, name: .BSPlayerViewControllerChangeTrackInfo, object: nil)
        NotificationCenter.default.removeObserver(self, name: .BSPlayerViewControllerChangePlaying, object: nil)
        NotificationCenter.default.removeObserver(self, name: .BSPlayerViewControllerChangeChannel, object: nil)
        NotificationCenter.default.removeObserver(self, name: .BSPlayerViewControllerNeedUpdate, object: nil)
    }
    
    @objc func applicationDidBecomeActive(notification: Notification) {
        self.appActive = true
        self.subscribeNotifications()
        self.needUpdate = true
        self.sendNeedUpdateMessage()
    }
    
    @objc func applicationWillResignActive(notification: Notification) {
        self.appActive = false
        self.unsubscribeNotifications()
        self.fullScreenLoading(active: true)
        self.needUpdate = true
    }
    
    func sendNeedUpdateMessage() {
        if !self.needUpdate {
            self.startNeedUpdateTimer(start: false)
            return
        }
        
        BSWatchConnectivityManager.shared.sendMessage(action: .needUpdate, message: nil)
        self.startNeedUpdateTimer(start: true)
    }
    
    @objc func openPage(notification: Notification) {
        self.channel = notification.object as? BSChannel
        
        DispatchQueue.main.async {
            self.isPlaying = true
            self.becomeCurrentPage()
        }
    }
    
    func update() {
        self.setTitle(self.channel?.name)
        
        if self.isLoading {
            self.titleLabel.setText(nil)
            self.artistLabel.setText("Loading...")
            
            self.trackPositionLabel.setText(nil)
            self.trackDurationLabel.setText(nil)
            
            self.loadingImageDrawer?.color = UIColor.white
            self.loadingImageDrawer?.isActive = true
        } else {
            self.loadingImageDrawer?.color = nil
            self.loadingImageDrawer?.isActive = self.isPlaying
            self.startTrackUpdateTimer(start: self.isPlaying)
        }
        
        self.updateTrackPosition()
        self.updateButtons()
    }
    
    func fullScreenLoading(active: Bool) {
        if active {
            self.setTitle("Loading...")
        } else {
            self.setTitle(self.channel?.name)
        }
        
        self.mainGroup.setHidden(active)
        self.loadingImage.setHidden(!active)
        self.fullScreenLoadingImageDrawer?.isActive = active
    }
    
    func updateButtons() {
        let imageName = self.isPlaying ? "pauseIcon" : "playIcon"
        self.playButton.setBackgroundImage(UIImage(named: imageName))
    }
    
    @IBAction func channels() {
        BSPagesManager.openPage(page: .channels, object: nil)
    }
    
    @IBAction func play() {
        if self.isLoading {
            return
        }
        
        self.isPlaying = !self.isPlaying
        
        let message = BSMessagePlayingDidChange(isPlaying: self.isPlaying)
        BSWatchConnectivityManager.shared.sendMessage(action: .playingDidChange, message: message)
    }
    
    @IBAction func like() {
        
    }
    
    func startTrackUpdateTimer(start: Bool) {
        DispatchQueue.main.async {
            if self.trackUpdateTimer != nil {
                self.trackUpdateTimer?.invalidate()
                self.trackUpdateTimer = nil
            }
            
            if !start {
                return
            }
        
            self.trackUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                self.updateTrackPosition()
            }
        }
    }
    
    func startNeedUpdateTimer(start: Bool) {
        DispatchQueue.main.async {
            if self.needUpdateTimer != nil {
                self.needUpdateTimer?.invalidate()
                self.needUpdateTimer = nil
            }
            
            if !start {
                return
            }
            
            self.needUpdateTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                self.sendNeedUpdateMessage()
            }
        }
    }
    
    func updateTrackPosition() {
        if self.playbackTime <= 0.0 && self.duration <= 0.0 {
            self.trackPositionLabel.setText(nil)
            self.trackDurationLabel.setText(nil)
            self.startTrackUpdateTimer(start: false)
            return
        }
        
        self.trackPositionLabel.setText(self.timeToString(seconds: Float(self.playbackTime)))
        if self.duration > 0.0 {
            self.trackDurationLabel.setText(self.timeToString(seconds: Float(self.duration)))
        }
        
        if !self.isPlaying {
            self.startTrackUpdateTimer(start: false)
        }
        
        self.playbackTime += Float64(1.0)
    }
    
    func timeToString(seconds: Float) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(seconds))
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        
        return formatter.string(from: date)
    }
    
    @objc func changeTrackInfo(notification: Notification) {
        if !self.appActive {
            return
        }
        
        DispatchQueue.main.async {
            let object = notification.object as! BSMessageTrackInfoDidChange
            self.changeTrackInfo(object: object)
        }
    }
    
    func changeTrackInfo(object: BSMessageTrackInfoDidChange) {
        let type: BSMusicManagerType? = BSMusicManagerType(rawValue: object.type!)
        switch type {
        case .DI?:
            self.track = BSDITrack(JSONString: object.track!)!
            break
        case .none:
            self.track = BSTrack(JSONString: object.track!)!
            break
        }
        
        self.playbackTime = object.playbackTime
        self.duration = object.duration
        
        self.titleLabel.setText(self.track?.title)
        self.artistLabel.setText(self.track?.artist)
        self.updateTrackPosition()
    }
    
    @objc func changePlaying(notification: Notification) {
        if !self.appActive {
            return
        }
        
        DispatchQueue.main.async {
            let object = notification.object as! BSMessagePlayingDidChange
            self.changePlaying(object: object)
        }
    }
    
    func changePlaying(object: BSMessagePlayingDidChange) {
        let isPlaying = object.isPlaying
        if self.isLoading && isPlaying {
            self.isLoading = false
        }
        self.isPlaying = isPlaying
        
        if self.needUpdate {
            self.needUpdate = false
            self.fullScreenLoading(active: false)
        }
    }
    
    @objc func changeChannel(notification: Notification) {
        if !self.appActive {
            return
        }
        
        DispatchQueue.main.async {
            let object = notification.object as! BSMessageChannelDidChange
            self.changeChannel(object: object)
        }
    }
    
    func changeChannel(object: BSMessageChannelDidChange) {
        let type: BSMusicManagerType? = BSMusicManagerType(rawValue: object.type!)
        switch type {
        case .DI?:
            self.channel = BSDIChannel(JSONString: object.channel!)!
            break
        case .none:
            self.channel = BSChannel(JSONString: object.channel!)!
            break
        }
        
        self.update()
    }
    
    @objc func needUpdate(notification: Notification) {
        if !self.appActive {
            return
        }
        
        DispatchQueue.main.async {
            let object = notification.object as! BSMessageNeedUpdate
            if let messageChannel = object.messageChannel {
                self.changeChannel(object: messageChannel)
            }
            
            if let messageTrackInfo = object.messageTrackInfo {
                self.changeTrackInfo(object: messageTrackInfo)
            }
            
            if let messagePlaying = object.messagePlaying {
                self.changePlaying(object: messagePlaying)
            }
        }
    }
    
}
