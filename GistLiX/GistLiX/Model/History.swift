//
//  History.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import Foundation
import SwiftyJSON
import Bond

class History: Model {
    var url = Observable<String?>(nil)
    var version = Observable<String?>(nil)
    var user = User()
    var committed_at = Observable<String?>(nil)
    
    
    class func modelsFromDictionaryArray(array:NSArray) -> [History]
    {
        var models:[History] = []
        for item in array
        {
            models.append(History(json: item as! JSON))
        }
        return models
    }
    
    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        url.value = json["url"].string
        version.value = json["version"].string
        if json["user"].exists() { user = User(json: json["user"]) }
        committed_at.value = json["committed_at"].string
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.url, forKey: "url")
        dictionary.setValue(self.version, forKey: "version")
        dictionary.setValue(self.user.dictionaryRepresentation(), forKey: "user")
        dictionary.setValue(self.committed_at, forKey: "committed_at")
        
        return dictionary
    }
    
}
