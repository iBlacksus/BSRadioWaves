// GNU General Public License v3.0
//
//  BSMusicManager.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/3/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Foundation

typealias getCategoriesCompletionHandler = (NSArray) -> Void
typealias getChannelCompletionHandler = (NSArray) -> Void
typealias getWaveformCompletionHandler = (NSArray) -> Void

protocol BSMusicManagerProtocol {
    func getCategories(completion: @escaping getCategoriesCompletionHandler)
    func getChannel(id: NSInteger, completion: @escaping getChannelCompletionHandler)
    func getWaveform(url: URL, completion: @escaping getWaveformCompletionHandler)
}
