// GNU General Public License v3.0
//
//  BSCategoriesController.swift
//  Watch
//
//  Created by iBlacksus on 11/20/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import WatchKit
import WatchConnectivity

class BSCategoriesController: WKInterfaceController {
    private var musicManager: BSMusicManagerProtocol?
    private var categories: NSMutableArray!
    private var channels: NSArray!
    private var isCategories = true
    private var selectedCategoryIndex: Int = 0
    private var loadingImageDrawer: BSWavesDrawerProxy?
    
    @IBOutlet var table: WKInterfaceTable!
    @IBOutlet var loadingImage: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openPage), name: .BSPagesManagerOpenChannels, object: nil)
        
        self.loadingImageDrawer = BSWavesDrawerProxy(image: self.loadingImage)
        self.loadingImageDrawer?.color = UIColor.white
        
        self.categories = NSMutableArray()
        self.channels = NSArray()
        
        let fabric = BSMusicManagerFabric()
        self.musicManager = fabric.manager(type: BSMusicManagerType.DI)
        BSFavoritesManager.shared.type = BSMusicManagerType.DI
        self.update()
    }
    
    @objc func openPage() {
        self.becomeCurrentPage()
    }
    
    func update() {
        self.loading(active: true)
        
        self.musicManager?.getCategories { (categories) in
            self.categories = categories.mutableCopy() as? NSMutableArray
            self.isCategories = true
            self.loadCategories()
            self.loading(active: false)
        }
    }
    
    func loading(active: Bool) {
        if active {
            self.setTitle("Loading...")
        }
        
        self.table.setHidden(active)
        self.loadingImage.setHidden(!active)
        self.loadingImageDrawer?.isActive = active
    }
    
    func loadCategories() {
        self.setTitle(Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String)
        self.table.setNumberOfRows(self.categories.count, withRowType: "BSCategoryRow")
        for (index, category) in self.categories.enumerated() {
            let row = self.table.rowController(at: index) as! BSCategoryRow
            row.category = category as? BSCategory
        }
        
        self.animate(withDuration: 0.25) {
            self.table.setAlpha(0.0)
            self.table.scrollToRow(at: self.selectedCategoryIndex)
            
            self.animate(withDuration: 0.25) {
                self.table.setAlpha(1.0)
            }
        }
    }
    
    func loadChannels() {
        self.table.setNumberOfRows(self.channels.count, withRowType: "BSChannelRow")
        for (index, channel) in self.channels.enumerated() {
            let row = self.table.rowController(at: index) as! BSChannelRow
            row.channel = channel as? BSChannel
        }
        
        let indexSet: IndexSet = [self.channels.count]
        self.table.insertRows(at: indexSet, withRowType: "BSBackRow")
        
        self.table.scrollToRow(at: 0)
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if self.isCategories {
            self.isCategories = false
            self.selectedCategoryIndex = rowIndex
            let category = self.categories[rowIndex] as? BSCategory
            self.channels = category?.channels as NSArray?
            self.setTitle(category?.name)
            self.loadChannels()
        } else {
            if rowIndex == self.channels.count {
                self.isCategories = true
                self.loadCategories()
                return
            }
            
            if !WCSession.default.isReachable {
                return
            }
            
            let channel = self.channels[rowIndex] as! BSChannel
            let message = BSMessageChannelDidChange(channel: channel, type: .DI)
            BSWatchConnectivityManager.shared.sendMessage(action: .channelDidChange, message: message)
            
            BSPagesManager.openPage(page: .player, object: channel)
        }
    }
}
