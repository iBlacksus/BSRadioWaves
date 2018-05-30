// GNU General Public License v3.0
//
//  BSCategoryRow.swift
//  BSRadioWaves
//
//  Created by Oleg Musinov on 11/20/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import WatchKit

class BSCategoryRow: NSObject {
    var category: BSCategory? {
        didSet {
            self.load()
        }
    }
    
    @IBOutlet var label: WKInterfaceLabel!
    
    func load() {
        self.label.setText(self.category?.name)
    }
}
