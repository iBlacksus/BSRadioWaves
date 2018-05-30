// GNU General Public License v3.0
//
//  BSFavoritesManager.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/15/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Foundation

struct BSFavoritesManagerConstants {
    static let favoritesKey = "favoritesKey"
    static let diKey = "diKey"
}

extension NSNotification.Name {
    public static let BSFavoritesManagerUpdated: NSNotification.Name = NSNotification.Name(rawValue: "BSFavoritesManagerUpdated")
}

class BSFavoritesManager: NSObject {
    var type: BSMusicManagerType?
    
    static let shared = BSFavoritesManager()
    
    func typeKey() -> String {
        switch self.type {
        case .DI?:
            return BSFavoritesManagerConstants.diKey
        case .none:
            return ""
        }
    }
    
    func getFavorites() -> NSArray {
        let key = BSFavoritesManagerConstants.favoritesKey + self.typeKey()
        var value = UserDefaults.standard.value(forKey: key)
        if value == nil {
            value = NSArray()
        } else {
            value = NSKeyedUnarchiver.unarchiveObject(with: value as! Data)
        }
        
        return value as! NSArray
    }
    
    func addFavorites(id: Int) {
        if self.isFavorites(id: id) {
            return
        }
        
        let favorites: NSMutableArray = self.getFavorites().mutableCopy() as! NSMutableArray
        favorites.add(id)
        self.saveFavorites(favorites: favorites)
    }
    
    func removeFavorites(id: Int) {
        let favorites: NSMutableArray = self.getFavorites().mutableCopy() as! NSMutableArray
        favorites.remove(id)
        self.saveFavorites(favorites: favorites)
    }
    
    func isFavorites(id: Int) -> Bool {
        let favorites = self.getFavorites()
        
        return favorites.contains(id)
    }
    
    func saveFavorites(favorites: NSArray) {
        let key = BSFavoritesManagerConstants.favoritesKey + self.typeKey()
        let data = NSKeyedArchiver.archivedData(withRootObject: favorites)
        UserDefaults.standard.setValue(data, forKeyPath: key)
        
        NotificationCenter.default.post(name: NSNotification.Name.BSFavoritesManagerUpdated, object: nil)
    }
}
