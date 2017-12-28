//
//  Authorizantion.swift
//  GistLiX
//
//  Created by Augusto Reis on 26/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import Foundation
import Locksmith

class Authorizantion: NSObject {
    
    private struct CredentialKey {
        static let userAccount = "com.github"
        static let userInfo = "user.github"
    }
    
    static func setUserCredential(user: String, password: String) {
        let basicAuth = "\(user):\(password)".data(using: .utf8)
        if let base64Auth = basicAuth?.base64EncodedString() {
            do {
                try Locksmith.saveData(data: ["basic":"Basic \(base64Auth)"], forUserAccount: CredentialKey.userAccount)
            }catch(let error) {
                print(error)
            }
        }
    }
    
    static func removeUserCredential() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: CredentialKey.userAccount)
        }catch(let error) {
            print(error)
        }
        let userDefaults = UserDefaults()
        userDefaults.removeObject(forKey: CredentialKey.userInfo)
    }
    
    static var userCredential: String? {
        get {
            if let base64Auth = Locksmith.loadDataForUserAccount(userAccount: CredentialKey.userAccount),
                let basicAuth = base64Auth["basic"] as? String{
                return basicAuth
            } else {
                return nil
            }
        }
    }
    
    static var username: String? {
        set {
            if let newUser = newValue {
                let userDefaults = UserDefaults()
                userDefaults.set(newUser, forKey: CredentialKey.userInfo)
            }
        }
        get {
            let userDefaults = UserDefaults()
            if let username = userDefaults.object(forKey: CredentialKey.userInfo) as? String {
                return username
            } else {
                return nil
            }
        }
    }
}
