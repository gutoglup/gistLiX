//
//  Comment.swift
//  GistLiX
//
//  Created by Augusto Reis on 25/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit
import Bond
import SwiftyJSON

class Comment: Model {
    
     var url = Observable<String?>(nil)
     var id = Observable<Int?>(nil)
     var user = User()
     var author_association = Observable<String?>(nil)
     var created_at = Observable<String?>(nil)
     var updated_at = Observable<String?>(nil)
     var body = Observable<String?>(nil)
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Comment]
    {
        var models:[Comment] = []
        for item in array
        {
            models.append(Comment(json: item as! JSON))
        }
        return models
    }
    
    required init(json: JSON) {
        super.init(json: json)

        url.value = json["url"].string
        id.value = json["id"].int
        if json["user"].exists() { user = User(json: json["user"] ) }
        author_association.value = json["author_association"].string
        created_at.value = json["created_at"].string
        updated_at.value = json["updated_at"].string
        body.value = json["body"].string
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.url, forKey: "url")
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.user.dictionaryRepresentation(), forKey: "user")
        dictionary.setValue(self.author_association, forKey: "author_association")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        dictionary.setValue(self.body, forKey: "body")
        
        return dictionary
    }
    
    
    
}
