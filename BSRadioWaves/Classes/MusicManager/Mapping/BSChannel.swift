// GNU General Public License v3.0
//
//  BSChannel.swift
//  BSRadioWaves
//
//  Created by Oleg Musinov on 11/1/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Foundation
import ObjectMapper

class BSChannel: Mappable {
    var name: String?
    var id: Int?
    var image: String?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        image <- map["image"]
    }
}
