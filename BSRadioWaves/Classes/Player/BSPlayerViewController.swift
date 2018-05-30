// GNU General Public License v3.0
//
//  BSPlayerViewController.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/3/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

extension NSNotification.Name {
    public static let BSPlayerViewControllerChangeChannel: NSNotification.Name = NSNotification.Name(rawValue: "BSPlayerViewControllerChangeChannel")
    public static let BSPlayerViewControllerDidLoad: NSNotification.Name = NSNotification.Name(rawValue: "BSPlayerViewControllerDidLoad")
    public static let BSPlayerViewControllerChangePlaying: NSNotification.Name = NSNotification.Name(rawValue: "BSPlayerViewControllerChangePlaying")
    public static let BSPlayerViewControllerNeedUpdate: NSNotification.Name = NSNotification.Name(rawValue: "BSPlayerViewControllerNeedUpdate")
}

class BSPlayerViewController: UIViewController {
    var channel: BSChannel?
    var isPlaying = false
    var audioPlayer: AVPlayer?
    var tracks: NSArray = []
    var trackIndex: Int = 0
    
    private var musicManager: BSMusicManagerProtocol?
    private var nextTracks: NSArray = []
    private var trackPositionObserver: Any?
    private var commandCenterPauseCommandTarget: Any?
    private var commandCenterPlayCommandTarget: Any?
    private var isLoading = false {
        didSet {
            self.playButton.isLoading = self.isLoading
        }
    }
    private var playerNotificationsHelper: BSPlayerNotificationsHelper!
    private var playerNetworkHelper: BSPlayerNetworkHelper!
    private var loadingChannels = false
    
    @IBOutlet var playButton: BSPlayButton!
    @IBOutlet var waveformView: BSWaveformView!
    @IBOutlet var trackPositionView: UIView!
    @IBOutlet var trackPositionViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var trackTimePositionLabel: UILabel!
    @IBOutlet var trackDurationLabel: UILabel!
    @IBOutlet var wavesView: BSWavesView!
    @IBOutlet var trackInfoView: BSTrackInfoView!
    @IBOutlet var likeImageView: UIImageView!
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var airplayImageView: UIImageView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.playerNotificationsHelper = BSPlayerNotificationsHelper(controller: self)
        self.playerNotificationsHelper.configureNotifications()
        
        self.playerNetworkHelper = BSPlayerNetworkHelper(controller: self)
        self.playerNetworkHelper.startNetworkReachabilityObserver()
        
        let fabric = BSMusicManagerFabric()
        self.musicManager = fabric.manager(type: BSMusicManagerType.DI)
        
        self.wavesView.isActive = false
        self.wavesView.isHidden = true
        self.wavesView.configurePanGesture()
        
        self.trackInfoView.trackImageLoadingCompleted = {
            () -> Void in
            self.updateNowPlayingInfoCenter()
        }
    }
    
    func updateStatus() {
        if self.channel != nil && self.tracks.count == 0 {
            self.update(autoplay: true)
        }
        
        if self.audioPlayer?.status != AVPlayerStatus.readyToPlay {
            self.isPlaying = false
        }
        
        if #available(iOS 10.0, *) {
            self.isPlaying = self.audioPlayer?.timeControlStatus == AVPlayerTimeControlStatus.playing
        }
        
        self.playTrack(play: self.isPlaying)
    }
    
    func configureAudioSession() {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
    }
    
    func configureRemoteCommandCenter() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.nextTrackCommand.isEnabled = false
        commandCenter.previousTrackCommand.isEnabled = false
        if self.commandCenterPauseCommandTarget != nil {
            commandCenter.pauseCommand.removeTarget(self.commandCenterPauseCommandTarget)
        }
        if self.commandCenterPlayCommandTarget != nil {
            commandCenter.playCommand.removeTarget(self.commandCenterPlayCommandTarget)
        }
        
        self.commandCenterPauseCommandTarget = commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            if self.audioPlayer?.status != AVPlayerStatus.readyToPlay || self.isLoading {
                return .noSuchContent
            }
            
            self.playTrack(play: false)
            return .success
        }
        
        self.commandCenterPlayCommandTarget = commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            if self.audioPlayer?.status != AVPlayerStatus.readyToPlay || self.isLoading {
                return .noSuchContent
            }
            
            self.playTrack(play: true)
            return .success
        }
    }
    
    func update(autoplay: Bool = false) {
        if self.loadingChannels {
            return
        }
        
        self.loadingChannels = true
        self.isLoading = true
        self.musicManager?.getChannel(id: (self.channel?.id)!) { (tracks) in
            self.loadingChannels = false
            
            if tracks.count == 0 {
                self.view.makeToast("Music service unavailable", duration: 1.25, position: .top)
                self.isLoading = false
                return
            }
            
            if self.tracks.count > 0 {
                self.nextTracks = tracks
            } else {
                self.tracks = tracks
            }
            
            if autoplay {
                self.trackIndex = -1
                self.nextTrack()
            }
        }
    }
    
    @IBAction func play(_ sender: UIButton) {
        if self.audioPlayer?.status != AVPlayerStatus.readyToPlay || self.isLoading {
            return
        }
        
        if #available(iOS 10.0, *) {
            self.isPlaying = self.audioPlayer?.timeControlStatus == AVPlayerTimeControlStatus.playing
        }
        
        self.playTrack(play: !self.isPlaying)
    }
    
    @IBAction func next(_ sender: UITapGestureRecognizer) {
        self.nextTrack()
    }
    
    @IBAction func airplay(_ sender: UIButton) {
        self.animateImageTap(imageView: self.airplayImageView, parentView: self.buttonsView)
        
        let rect = CGRect(x: -100, y: 0, width: 0, height: 0)
        let airplayVolume = MPVolumeView(frame: rect)
        airplayVolume.showsVolumeSlider = false
        self.view.addSubview(airplayVolume)
        for view: UIView in airplayVolume.subviews {
            if let button = view as? UIButton {
                button.sendActions(for: .touchUpInside)
                break
            }
        }
        airplayVolume.removeFromSuperview()
    }
    
    @IBAction func like(_ sender: UIButton) {
        if self.tracks.count == 0 {
            return
        }
        
        let track = self.tracks[self.trackIndex] as! BSTrack
        BSLikesManager.addLike(artist: track.artist, title: track.title)
        
        self.animateImageTap(imageView: self.likeImageView, parentView: self.buttonsView)
    }
    
    func playTrack(play: Bool) {
        if self.audioPlayer?.status != AVPlayerStatus.readyToPlay || self.isLoading {
            return
        }
        
        self.isPlaying = play
        
        if play {
            self.configureAudioSession()
            self.configureRemoteCommandCenter()
            self.audioPlayer?.play()
        } else {
            self.audioPlayer?.pause()
        }
        
        self.playButton.isPlaying = play
        self.wavesView.isActive = play
        
        self.updateNowPlayingInfoCenter()
        
        let message = BSMessagePlayingDidChange(isPlaying: play)
        BSWatchConnectivityManager.shared.sendMessage(action: .playingDidChange, message: message)
        
        self.timeCorrection()
    }
    
    func timeCorrection() {
        let deadlineTime = DispatchTime.now() + .milliseconds(2000)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.updateNowPlayingInfoCenter()
        }
    }
    
    func nextTrack() {
        if self.nextTracks.count > 0 {
            self.tracks = self.nextTracks
            self.nextTracks = []
            self.trackIndex = -1
        }
        
        self.trackIndex += 1
        if self.trackIndex == self.tracks.count - 1 {
            self.update()
        }
        else if self.trackIndex >= self.tracks.count {
            self.trackIndex = 0
        }
        
        let track = self.tracks[self.trackIndex] as! BSTrack
        self.loadTrack(track: track)
    }
    
    func checkTrackLoadingStatus() {
        if self.audioPlayer?.status == AVPlayerStatus.failed {
            self.isLoading = false
            self.isPlaying = false
            return
        }
        
        if self.audioPlayer?.status != AVPlayerStatus.readyToPlay {
            let deadlineTime = DispatchTime.now() + .milliseconds(500)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.checkTrackLoadingStatus()
            }
            return
        }
        
        self.isLoading = false
        self.wavesView.isActive = true
        self.isPlaying = true
        self.configureRemoteCommandCenter()
        self.updateNowPlayingInfoCenter()
        
        let message = BSMessagePlayingDidChange(isPlaying: self.isPlaying)
        BSWatchConnectivityManager.shared.sendMessage(action: .playingDidChange, message: message)
        
        self.timeCorrection()
        
        self.trackPositionObserver = self.audioPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.audioPlayer!.currentItem?.status != .readyToPlay {
                return
            }
            
            self.waveformView.bringSubview(toFront: self.trackPositionView)
            let length = CMTimeGetSeconds((self.audioPlayer!.currentItem?.asset.duration)!)
            let time = CMTimeGetSeconds(self.audioPlayer!.currentTime())
            self.trackPositionViewLeadingConstraint.constant = self.waveformView.bounds.width / CGFloat(length) * CGFloat(time)
            self.trackTimePositionLabel.text = self.timeToString(seconds: Float(time))
            self.trackDurationLabel.text = self.timeToString(seconds: Float(length))
            
            if length > 0.0 && time > length {
                self.playTrack(play: false)
            }
        }
    }
    
    func loadTrack(track: BSTrack) {
        let url = URL(string: "http:" + track.url!)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        self.audioPlayer = AVPlayer(playerItem: playerItem)
        self.audioPlayer?.play()
        self.playButton.isPlaying = true
        self.wavesView.isHidden = false
        self.trackInfoView.track = track
        self.trackInfoView.channel = self.channel
        if track.waveform != nil {
            self.waveformView.url = track.waveform
        } else {
            
        }
        
        if !self.isLoading {
            self.isLoading = true
            self.wavesView.isActive = false
        }
        
        self.configureAudioSession()
        self.configureRemoteCommandCenter()
        self.checkTrackLoadingStatus()
        
        self.trackPositionViewLeadingConstraint.constant = 0.0
    }
    
    func updateNowPlayingInfoCenter() {
        let track = self.tracks[self.trackIndex] as! BSTrack
        
        let duration = CMTimeGetSeconds((self.audioPlayer?.currentItem!.duration)!)
        let time = CMTimeGetSeconds((self.audioPlayer?.currentTime())!)
        let dictionary = NSMutableDictionary()
        
        dictionary[MPMediaItemPropertyTitle] = track.title
        dictionary[MPMediaItemPropertyArtist] = track.artist
        dictionary[MPMediaItemPropertyPlaybackDuration] = duration
        dictionary[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
        dictionary[MPNowPlayingInfoPropertyPlaybackRate] = self.isPlaying ? 1 : 0
        if self.trackInfoView.trackImage != nil {
            if #available(iOS 10.0, *) {
                dictionary[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: (self.trackInfoView.trackImage?.size)!, requestHandler: { (size) -> UIImage in
                    return self.trackInfoView.trackImage!
                })
            } else {
                dictionary[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: self.trackInfoView.trackImage!)
            }
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = dictionary as? [String : Any]
        
        let message = BSMessageTrackInfoDidChange(track: track, type: .DI, playbackTime: time, duration: duration)
        BSWatchConnectivityManager.shared.sendMessage(action: .trackInfoDidChange, message: message)
    }
    
    
    func timeToString(seconds: Float) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(seconds))
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        
        return formatter.string(from: date)
    }
    
    
}
