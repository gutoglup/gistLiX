//
//  GistViewModel.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit

protocol GistDelegate: class {
    func didFinishLoading()
}

class GistViewModel: ViewModel {
    
    weak var delegate: GistDelegate?
    
    var resultQrcode: String = String()
    var gistModel = GistModel()
    
    override init() {
        super.init()
        
    }
    
    func loadGist() {
        let request = ServiceModel()
        
        request.fetch(GistModel.self, requestLink: .gistDetail, parameters: ["id": resultQrcode]) { (response) in
            if let gistModel = response as? GistModel {
                self.gistModel = gistModel
                self.delegate?.didFinishLoading()
            }
        }
    }

}
