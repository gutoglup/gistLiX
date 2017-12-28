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
import Locksmith

protocol GistCommentDelegate: class {
    func didFinishLoading()
    func loginUser()
}

class GistCommentViewModel: ViewModel {

    weak var delegate: GistCommentDelegate?
    
    var resultQrcode = String()
    var gistComments = [Comment]()
    var comment = Observable<String?>("")
    
    @objc func postCommentAction() {
        
        
        
        let request = ServiceModel()
        
        if isAccountSaved() {
            if isValidaComment() {
                request.push(Comment.self, requestLink: .gistListComments, parameters: ["body": comment.value!, "id": resultQrcode]) { (response) in
                    if response is Comment {
                        self.loadComments()
                    }
                }
            }
            
        }else {
            self.delegate?.loginUser()
        }
        
        
    }
    
    func isAccountSaved() -> Bool {
        if ((Authorizantion.userCredential) != nil) {
            return true
        }
        return false
    }
    
    func isValidaComment() -> Bool {
        if let comment = comment.value {
            return !comment.isEmpty
        }
        return false
    }
    
    func loadComments() {
        let request = ServiceModel()
        
        request.fetch(Comment.self, requestLink: .gistComments, parameters: ["id":resultQrcode]) { (response) in
            if let gistComments = response as? [Comment] {
                self.gistComments = gistComments
                self.cleanComment()
                self.delegate?.didFinishLoading()
            }
        }
    }
    
    func cleanComment() {
        self.comment.value = ""
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
