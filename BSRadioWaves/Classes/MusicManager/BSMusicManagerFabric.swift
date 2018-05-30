// GNU General Public License v3.0
//
//  BSMusicManagerFabric.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/4/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Foundation

enum BSMusicManagerType: String {
    case DI = "DI"
}

class BSMusicManagerFabric: NSObject {
    func manager(type: BSMusicManagerType) -> BSMusicManagerProtocol {
        switch type {
        case BSMusicManagerType.DI:
            return BSDIMusicManager()
        }
    }
}
