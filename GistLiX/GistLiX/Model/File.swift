//
//  File.swift
//  GistLiX
//
//  Created by Augusto Reis on 25/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit
import Bond
import SwiftyJSON


class File: Model {

     var size = Observable<Int?>(nil)
     var raw_url = Observable<String?>(nil)
     var type = Observable<String?>(nil)
     var language = Observable<String?>(nil)
     var truncated = Observable<Bool?>(nil)
     var content = Observable<String?>(nil)

    class func modelsFromDictionary(dictionary:[String: JSON]) -> [String:File]
    {
        var models:[String:File] = [:]
        for (key, item) in dictionary {
            models[key] = File(json: item)
        }
        return models
    }
    
    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        
        size.value = json["size"].int
        raw_url.value = json["raw_url"].string
        type.value = json["type"].string
        language.value = json["language"].string
        truncated.value = json["truncated"].bool
        content.value = json["content"].string
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.size, forKey: "size")
        dictionary.setValue(self.raw_url, forKey: "raw_url")
        dictionary.setValue(self.type, forKey: "type")
        dictionary.setValue(self.language, forKey: "language")
        dictionary.setValue(self.truncated, forKey: "truncated")
        dictionary.setValue(self.content, forKey: "content")
        
        return dictionary
    }
    
    
    
}
