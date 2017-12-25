//
//  Forks.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import Foundation
import SwiftyJSON
import Bond

class Forks: Model {
	 var user = User()
	 var url = Observable<String?>(nil)
	 var id = Observable<String?>(nil)
	 var created_at = Observable<String?>(nil)
	 var updated_at = Observable<String?>(nil)


     class func modelsFromDictionaryArray(array:NSArray) -> [Forks]
    {
        var models:[Forks] = []
        for item in array
        {
            models.append(Forks(json: item as! JSON))
        }
        return models
    }

    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)

        if (json["user"].exists()) { user = User(json: json["user"] ) }
		url.value = json["url"].string
		id.value = json["id"].string
		created_at.value = json["created_at"].string
		updated_at.value = json["updated_at"].string
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	 func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.user.dictionaryRepresentation(), forKey: "user")
		dictionary.setValue(self.url, forKey: "url")
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.updated_at, forKey: "updated_at")

		return dictionary
	}

}
