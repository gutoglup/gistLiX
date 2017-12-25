//
//  GistModel.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import Foundation
import SwiftyJSON
import Bond

class GistModel: Model {
    
    var url = Observable<String?>(nil)
    var forks_url = Observable<String?>(nil)
    var commits_url = Observable<String?>(nil)
    var id = Observable<String?>(nil)
    var description = Observable<String?>(nil)
    var publicGist = Observable<Bool?>(nil)
    var owner = Owner()
    var user = Observable<String?>(nil)
    var truncated = Observable<Bool?>(nil)
    var comments = Observable<Int?>(nil)
    var comments_url = Observable<String?>(nil)
    var html_url = Observable<String?>(nil)
    var git_pull_url = Observable<String?>(nil)
    var git_push_url = Observable<String?>(nil)
    var created_at = Observable<String?>(nil)
    var updated_at = Observable<String?>(nil)
    var forks = Array<Forks>()
    var history = Array<History>()
    
    
    class func modelsFromDictionaryArray(array:NSArray) -> [GistModel]
    {
        var models:[GistModel] = []
        for item in array
        {
            models.append(GistModel(json: item as! JSON))
        }
        return models
    }
    
    override init() {
        super.init()
    }
    
    
    required init(json: JSON) {
        super.init(json: json)
        url.value = json["url"].string
        forks_url.value = json["forks_url"].string
        commits_url.value = json["commits_url"].string
        id.value = json["id"].string
        description.value = json["description"].string
        publicGist.value = json["public"].bool
        
        if json["owner"].exists() { owner = Owner(json: json["owner"]) }
        user.value = json["user"].string
        truncated.value = json["truncated"].bool
        comments.value = json["comments"].int
        comments_url.value = json["comments_url"].string
        html_url.value = json["html_url"].string
        git_pull_url.value = json["git_pull_url"].string
        git_push_url.value = json["git_push_url"].string
        created_at.value = json["created_at"].string
        updated_at.value = json["updated_at"].string
        if json["forks"].exists() { forks = Forks.modelsFromDictionaryArray(array: json["forks"].array! as NSArray) }
        if json["history"].exists() { history = History.modelsFromDictionaryArray(array: json["history"].array! as NSArray) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.url, forKey: "url")
        dictionary.setValue(self.forks_url, forKey: "forks_url")
        dictionary.setValue(self.commits_url, forKey: "commits_url")
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.publicGist, forKey: "public")
        dictionary.setValue(self.owner.dictionaryRepresentation(), forKey: "owner")
        dictionary.setValue(self.user, forKey: "user")
        dictionary.setValue(self.truncated, forKey: "truncated")
        dictionary.setValue(self.comments, forKey: "comments")
        dictionary.setValue(self.comments_url, forKey: "comments_url")
        dictionary.setValue(self.html_url, forKey: "html_url")
        dictionary.setValue(self.git_pull_url, forKey: "git_pull_url")
        dictionary.setValue(self.git_push_url, forKey: "git_push_url")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        
        return dictionary
    }
    
    
}
