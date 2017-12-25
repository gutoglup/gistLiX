//
//  GistCommentViewModel.swift
//  GistLiX
//
//  Created by Augusto Reis on 25/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit
import Kingfisher
import Bond

protocol GistCommentDelegate: class {
    func didFinishLoading()
}

class GistCommentViewModel: ViewModel {

    weak var delegate: GistCommentDelegate?
    
    var resultQrcode = String()
    var gistComments = [Comment]()
    var comment = Observable<String?>("")
    
    @objc func postCommentAction() {
        
    }
    
    func loadComments() {
        let request = ServiceModel()
        
        request.fetch(Comment.self, requestLink: .gistComments, parameters: ["id":resultQrcode]) { (response) in
            if let gistComments = response as? [Comment] {
                self.gistComments = gistComments
                self.delegate?.didFinishLoading()
            }
        }
    }
    
    func countCommentsForGist() -> Int {
        return gistComments.count
    }
    
    func commentByIndex(indexPath: IndexPath) -> Comment {
        return gistComments[indexPath.row]
    }
    
    func usernameForComment(indexPath: IndexPath) -> String {
        let comment = commentByIndex(indexPath: indexPath)
        return comment.user.login.value ?? ""
    }
    
    func bodyForComment(indexPath: IndexPath) -> String {
        let comment = commentByIndex(indexPath: indexPath)
        return comment.body.value ?? ""
    }
    
    func userImageForComment(imageView: UIImageView, indexPath: IndexPath){
        let comment = commentByIndex(indexPath: indexPath)
        if let avatarUrl = comment.user.avatar_url.value,
            let url = URL(string: avatarUrl) {
            imageView.kf.setImage(with: url)
        }
    }
}
