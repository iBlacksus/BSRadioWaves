// GNU General Public License v3.0
//
//  BSLikesManager.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/14/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Foundation

struct BSLikesManagerConstants {
    static let likesKey = "likesKey"
}

extension NSNotification.Name {
    public static let BSLikesManagerUpdated: NSNotification.Name = NSNotification.Name(rawValue: "BSLikesManagerUpdated")
}

class BSLikesManager: NSObject {
    static func getLikes() -> NSArray {
        var value = UserDefaults.standard.value(forKey: BSLikesManagerConstants.likesKey)
        if value == nil {
            value = NSArray()
        } else {
            value = NSKeyedUnarchiver.unarchiveObject(with: value as! Data)
        }
        return value as! NSArray
    }
    
    static func addLike(artist: String?, title: String?) {
        let likes: NSMutableArray = self.getLikes().mutableCopy() as! NSMutableArray
        var string = ""
        if artist != nil {
            string += artist!
        }
        if title != nil {
            if string.count > 0 {
                string += " - "
            }
            string += title!
        }
        if likes.contains(string) {
            return
        }
        
        likes.insert(string, at: 0)
        self.saveLikes(likes: likes)
    }
    
    static func removeLike(string: String) {
        let likes: NSMutableArray = self.getLikes().mutableCopy() as! NSMutableArray
        likes.remove(string)
        self.saveLikes(likes: likes)
    }
    
    private static func saveLikes(likes: NSArray) {
        let data = NSKeyedArchiver.archivedData(withRootObject: likes)
        UserDefaults.standard.setValue(data, forKeyPath: BSLikesManagerConstants.likesKey)
        
        NotificationCenter.default.post(name: NSNotification.Name.BSLikesManagerUpdated, object: nil)
    }
}
