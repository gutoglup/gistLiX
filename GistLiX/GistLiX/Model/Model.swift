//
//  Model.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit

import SwiftyJSON

class Model {
    
    // MARK: - Constructors -
    
    init() {
        
    }
    
    convenience init(object : Any) {
        self.init(json: JSON(object))
    }
    
    required init(json: JSON) {
        
    }
}
