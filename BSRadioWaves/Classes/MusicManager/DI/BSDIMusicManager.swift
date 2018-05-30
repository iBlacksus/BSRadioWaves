// GNU General Public License v3.0
//
//  BSMusicManager.swift
//  BSRadioWaves
//
//  Created by iBlacksus on 11/1/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class BSDIMusicManager: NSObject, BSMusicManagerProtocol {
    func checkApiKey() -> Bool {
        if BSDIAppUrl.apiKey.count != 0 {
            return true
        }
        
        NSLog("!!Please insert API key!!!")
        return false
    }
    
    func getCategories(completion: @escaping getCategoriesCompletionHandler) {
        if !self.checkApiKey() {
            completion([])
        }
        
        if let response = BSCacheManager.shared.cachedResponse(request: BSDIAppUrl.batchUpdateURL) {
            let string = NSString(data: response as! Data, encoding: String.Encoding.utf8.rawValue)
            if (string?.length)! > 1000 {
                let object = BSDIBatchUpdateResponse(JSONString: string! as String)
                self.getCategoriesResponse(response: object!, completion: completion)
                return
            }
        }
        
        Alamofire.request(BSDIAppUrl.batchUpdateURL, headers: BSDIAppUrl.headers)
            .validate(statusCode: [200])
            .responseObject { (response: DataResponse<BSDIBatchUpdateResponse>) in
                
            switch response.result {
                case .success(let batchUpdateResponse):
                    BSCacheManager.shared.saveResponse(request: BSDIAppUrl.batchUpdateURL, response: response.data!)
                    self.getCategoriesResponse(response: batchUpdateResponse, completion: completion)
                
                case .failure(let error):
                    print(error)
                    completion([])
            }
            
        }
    }
    
    func getCategoriesResponse(response: BSDIBatchUpdateResponse, completion: @escaping getCategoriesCompletionHandler) {
        if !self.checkApiKey() {
            completion([])
        }
        
        let categories: NSMutableArray = []
        let excludeCategories = ["all", "new", "popular"]
        for object in response.channelFilters! as NSArray {
            let category = object as! BSCategory
            if excludeCategories.contains((category.name?.lowercased())!) || (category.channels?.count)! < 3 {
                continue
            }
            categories.add(category)
        }
        completion(categories)
    }
    
    func getChannel(id: NSInteger, completion: @escaping getChannelCompletionHandler) {
        if !self.checkApiKey() {
            completion([])
        }
        
        let url = String(format: BSDIAppUrl.channelURL, id)
        
        Alamofire.request(url, headers: BSDIAppUrl.headers)
            .validate(statusCode: [200])
            .responseObject { (response: DataResponse<BSDIChannelResponse>) in
                
                switch response.result {
                case .success(let channelResponse):
                    completion(channelResponse.tracks! as NSArray)
                    
                case .failure(let error):
                    print(error)
                    completion([])
                }
                
        }
    }
    
    func getWaveform(url: URL, completion: @escaping getWaveformCompletionHandler) {
        if !self.checkApiKey() {
            completion([])
        }
        
        Alamofire.request(url, headers: BSDIAppUrl.headers)
            .validate(statusCode: [200])
            .responseJSON { response in
                
                switch response.result {
                case .success(let waveform):
                    completion(waveform as! NSArray)
                    
                case .failure(let error):
                    print(error)
                    completion([])
                }
                
        }
    }
    
}
