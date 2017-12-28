//
//  GistCommentViewController.swift
//  GistLiX
//
//  Created by Augusto Reis on 25/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit
import GrowingTextView

class GistCommentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textViewComment: GrowingTextView!
    @IBOutlet weak var buttonComment: UIButton!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    let viewModel = GistCommentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate =  self
        viewModel.loadComments()
        
        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
        
        addActions()
        addBindings()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addActions() {
        viewModel.add(action: #selector(viewModel.postCommentAction), view: buttonComment)
    }
    
    func addBindings() {
        viewModel.comment.bidirectionalBind(to: textViewComment.reactive.text)
    }
    
    
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = view.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = keyboardHeight + 8
            buttonBottomConstraint.constant = keyboardHeight + 8
            view.layoutIfNeeded()
        }
    }
    
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
    
    
}

extension GistCommentViewController: GistCommentDelegate {
    
    func didFinishLoading() {
        self.textViewComment.resignFirstResponder()
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: self.tableView.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: true)
    }
    
    func loginUser() {
        self.performSegue(withIdentifier: LoginGithubTableViewController.segueIdentifier, sender: self)
    }
    
}

extension GistCommentViewController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension GistCommentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

extension GistCommentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countCommentsForGist()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as GistCommentCell
        cell.labelUsername.text = viewModel.usernameForComment(indexPath: indexPath)
        cell.labelComment.text = viewModel.bodyForComment(indexPath: indexPath)
        viewModel.userImageForComment(imageView: cell.imageUser, indexPath: indexPath)
        
        return cell
    }

}
