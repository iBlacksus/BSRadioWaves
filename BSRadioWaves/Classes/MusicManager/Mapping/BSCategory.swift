// GNU General Public License v3.0
//
//  BSCategory.swift
//  BSRadioWaves
//
//  Created by Oleg Musinov on 11/1/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Foundation
import ObjectMapper

class BSCategory: Mappable {
    var name: String?
    var channels: [BSChannel]?
    var isFavorite = false
    
    required init?(map: Map){}
    required init?(){}
    
    func mapping(map: Map) {}
}
