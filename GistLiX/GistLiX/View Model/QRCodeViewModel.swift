//
//  QRCodeViewModel.swift
//  GistLiX
//
//  Created by Augusto Reis on 23/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit

protocol QRCodeDelegate: class {
    func showLoggedAccount(username: String)
    func doLogin()
}

class QRCodeViewModel: ViewModel {
    
    weak var delegate: QRCodeDelegate?
    
    var resultQrcode: String = String()
    
    func showLoggedAccount() {
        if let username = Authorizantion.username {
            self.delegate?.showLoggedAccount(username: username)
        } else {
            self.delegate?.doLogin()
        }
    }
    
    func logoutAccountAction() {
        Authorizantion.removeUserCredential()
    }
}
