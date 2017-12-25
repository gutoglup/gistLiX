//
//  User.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import Foundation
import SwiftyJSON
import Bond

class User: Model {
    
    var login = Observable<String?>(nil)
    var id = Observable<Int?>(nil)
    var avatar_url = Observable<String?>(nil)
    var gravatar_id = Observable<String?>(nil)
    var url = Observable<String?>(nil)
    var html_url = Observable<String?>(nil)
    var followers_url = Observable<String?>(nil)
    var following_url = Observable<String?>(nil)
    var gists_url = Observable<String?>(nil)
    var starred_url = Observable<String?>(nil)
    var subscriptions_url = Observable<String?>(nil)
    var organizations_url = Observable<String?>(nil)
    var repos_url = Observable<String?>(nil)
    var events_url = Observable<String?>(nil)
    var received_events_url = Observable<String?>(nil)
    var type = Observable<String?>(nil)
    var site_admin = Observable<Bool?>(nil)
    
    
    class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(json: item as! JSON))
        }
        return models
    }
    
    override init() {
        super.init()
    }
    
    
    required init(json: JSON) {
        super.init(json: json)
        login.value = json["login"].string
        id.value = json["id"].int
        avatar_url.value = json["avatar_url"].string
        gravatar_id.value = json["gravatar_id"].string
        url.value = json["url"].string
        html_url.value = json["html_url"].string
        followers_url.value = json["followers_url"].string
        following_url.value = json["following_url"].string
        gists_url.value = json["gists_url"].string
        starred_url.value = json["starred_url"].string
        subscriptions_url.value = json["subscriptions_url"].string
        organizations_url.value = json["organizations_url"].string
        repos_url.value = json["repos_url"].string
        events_url.value = json["events_url"].string
        received_events_url.value = json["received_events_url"].string
        type.value = json["type"].string
        site_admin.value = json["site_admin"].bool
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.login, forKey: "login")
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.avatar_url, forKey: "avatar_url")
        dictionary.setValue(self.gravatar_id, forKey: "gravatar_id")
        dictionary.setValue(self.url, forKey: "url")
        dictionary.setValue(self.html_url, forKey: "html_url")
        dictionary.setValue(self.followers_url, forKey: "followers_url")
        dictionary.setValue(self.following_url, forKey: "following_url")
        dictionary.setValue(self.gists_url, forKey: "gists_url")
        dictionary.setValue(self.starred_url, forKey: "starred_url")
        dictionary.setValue(self.subscriptions_url, forKey: "subscriptions_url")
        dictionary.setValue(self.organizations_url, forKey: "organizations_url")
        dictionary.setValue(self.repos_url, forKey: "repos_url")
        dictionary.setValue(self.events_url, forKey: "events_url")
        dictionary.setValue(self.received_events_url, forKey: "received_events_url")
        dictionary.setValue(self.type, forKey: "type")
        dictionary.setValue(self.site_admin, forKey: "site_admin")
        
        return dictionary
    }
    
}
