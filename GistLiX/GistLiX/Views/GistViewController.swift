//
//  GistViewController.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit

class GistViewController: UITableViewController {
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var buttonComments: UIButton!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelCode: UILabel!
    
    var resultQrcode: String = String()
    
    let viewModel = GistViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.loadGist()
        
        addActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addActions() {
        
    }
    
    func addBindings() {
        viewModel.gistModel.owner.login.bind(to: labelUsername.reactive.text)
        viewModel.gistModel.comments.map({"\($0 ?? 0) Comments"}).bind(to: buttonComments.reactive.title)
        viewModel.gistModel.description.bind(to: labelDescription.reactive.text)
        
    }

}

extension GistViewController: GistDelegate {
    func didFinishLoading() {
        addBindings()
    }
}
