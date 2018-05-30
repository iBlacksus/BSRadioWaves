// GNU General Public License v3.0
//
//  BSCacheManager.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/20/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Foundation
import CryptoSwift

class BSCacheManager: NSObject {
    static let shared = BSCacheManager()
    
    func cachedResponse(request: String) -> Any? {
        guard let file = self.filePath(request: request) else {
            return nil
        }
        
        if !FileManager.default.fileExists(atPath: file) {
            return nil
        }
        
        let key = request.md5()
        let date = UserDefaults.standard.double(forKey: key)
        let curDate = NSDate().timeIntervalSince1970
        
        if curDate - date > 60 * 60 * 24 {
            try! FileManager.default.removeItem(atPath: file)
            UserDefaults.standard.removeObject(forKey: key)
            return nil
        }
        
        return NSData(contentsOfFile: file)
    }
    
    func saveResponse(request: String, response: Data) {
        guard let file = self.filePath(request: request) else {
            return
        }
        
        if !FileManager.default.createFile(atPath: file, contents: response, attributes: nil) {
            print("file not found:" + file)
        }
        UserDefaults.standard.set(NSDate().timeIntervalSince1970, forKey: request.md5())
    }
    
    func filePath(request: String) -> String? {
        guard let dir = self.cacheDirectory() else {
            return nil
        }
        
        let key = request.md5()
        
        return NSURL(fileURLWithPath: dir).appendingPathComponent(key)?.path
    }
    
    func cacheDirectory() -> String? {
        guard let tempDirURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("cache") else {
            return nil
        }
        
        if FileManager.default.fileExists(atPath: tempDirURL.path) {
            return tempDirURL.path
        }
        
        do {
            try FileManager.default.createDirectory(at: tempDirURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        
        return tempDirURL.absoluteString
    }
}
