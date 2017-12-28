//
//  LoginGithubViewModel.swift
//  GistLiX
//
//  Created by Augusto Reis on 27/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit
import Bond

protocol LoginGithubDelegate: class {
    func loginSuccessful()
    func loginFailed()
}

class LoginGithubViewModel: ViewModel {

    weak var delegate: LoginGithubDelegate?
    
    var username = Observable<String?>("")
    var password = Observable<String?>("")
    
    @objc func doLogin() {
        
        if isUsernameValid() && isPasswordValid() {
            let request = ServiceModel()
            if let username = username.value, let password = password.value {
                Authorizantion.setUserCredential(user: username, password: password)
                request.fetch(User.self, requestLink: .gitAuthentication, parameters: nil, handlerObject: { (response) in
                    if let user = response as? User {
                        if let username = user.login.value {
                            Authorizantion.username = username
                            self.delegate?.loginSuccessful()
                        } else {
                            Authorizantion.removeUserCredential()
                            self.delegate?.loginFailed()
                        }
                    } else {
                        Authorizantion.removeUserCredential()
                        self.delegate?.loginFailed()
                    }
                })
            }
        }
    }
    
    func isUsernameValid() -> Bool {
        if let username = username.value {
            return !username.isEmpty
        }
        return false
    }
    
    func isPasswordValid() -> Bool {
        if let password = password.value {
            return !password.isEmpty
        }
        return false
    }
    
}
