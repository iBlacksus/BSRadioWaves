// GNU General Public License v3.0
//
//  BSTrack.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/1/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Foundation
import ObjectMapper

class BSTrack: Mappable {
    var artist: String?
    var title: String?
    var lenght: Int?
    var waveform: String?
    var url: String?
    var image: String?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {}
}
