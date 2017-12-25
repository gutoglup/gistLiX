//
//  GistViewModel.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit
import Kingfisher

protocol GistDelegate: class {
    func didFinishLoading()
    func showCommentsViewController()
}

class GistViewModel: ViewModel {
    
    weak var delegate: GistDelegate?
    
    var resultQrcode = String()
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
    
    @objc func showCommentsAction() {
        self.delegate?.showCommentsViewController()
    }
    
    func ursernameForGist() -> String {
        return gistModel.owner.login.value ?? ""
    }
    
    func userImageForGist(imageView: UIImageView) {
        if let avatarUrl = gistModel.owner.avatar_url.value,
            let url = URL(string: avatarUrl) {
            imageView.kf.setImage(with: url)
        }
    }
    
    func commentsForGist() -> String {
        return "\(gistModel.comments.value ?? 0) Comments"
    }
    
    func descriptionForGist() -> String{
        return "\(gistModel.description.value ?? "Sem descrição")"
    }
    
    func filenameForGist(index: Int) -> String {
        let keys = Array(gistModel.files.keys)
        return keys[index]
    }
    
    func countFilesForGist() -> Int {
        return gistModel.files.count
    }

}
