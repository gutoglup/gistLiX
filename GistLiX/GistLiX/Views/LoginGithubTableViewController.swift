//
//  LoginGithubTableViewController.swift
//  GistLiX
//
//  Created by Augusto Reis on 27/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class LoginGithubTableViewController: UITableViewController, ReusableView {

    @IBOutlet weak var textFieldUsername: JVFloatLabeledTextField!
    @IBOutlet weak var textFeldPassword: JVFloatLabeledTextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    
    let viewModel = LoginGithubViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        addBindings()
        addActions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addBindings() {
        viewModel.username.bidirectionalBind(to: textFieldUsername.reactive.text)
        viewModel.password.bidirectionalBind(to: textFeldPassword.reactive.text)
    }
    
    func addActions() {
        viewModel.add(action: #selector(viewModel.doLogin), view: buttonLogin)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
}

extension LoginGithubTableViewController: LoginGithubDelegate {
    func loginSuccessful() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginFailed() {
        let alert = UIAlertController(title: "Login Failed", message: "Check your username and password", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}
