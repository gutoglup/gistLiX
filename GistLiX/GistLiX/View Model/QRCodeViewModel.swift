//
//  QRCodeViewModel.swift
//  GistLiX
//
//  Created by Augusto Reis on 23/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit

protocol QRCodeDelegate: class {
    
}

class QRCodeViewModel: ViewModel {
    
    weak var delegate: QRCodeDelegate?
    
    var resultQrcode: String = String()
    
    
}
