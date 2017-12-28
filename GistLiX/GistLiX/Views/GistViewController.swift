//
//  GistViewController.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit

class GistViewController: UITableViewController {
    
    var resultQrcode: String = String()
    
    let viewModel = GistViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadGist()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Delegate -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return viewModel.countFilesForGist()
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as GistUserCell
                cell.labelUsername.text = viewModel.ursernameForGist()
                viewModel.userImageForGist(imageView: cell.imageUser)
                cell.buttonComment.setTitle(viewModel.commentsForGist(), for: .normal)
                viewModel.add(action: #selector(viewModel.showCommentsAction), view: cell.buttonComment)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as GistDescriptionCell
                cell.labelDescription.text = viewModel.descriptionForGist()
                return cell
            default: break
            }
        case 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as GistFileCell
            cell.buttonFilename.setTitle(viewModel.filenameForGist(index: indexPath.row), for: .normal)
            
            return cell
            
        default: break
            
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Description"
        case 1:
            return "Files"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? GistCommentViewController {
            destinationViewController.viewModel.resultQrcode = viewModel.resultQrcode
        }
    }

}

extension GistViewController: GistDelegate {
    func didFinishLoading() {
        self.tableView.reloadData()
    }
    
    func showCommentsViewController() {
        self.performSegue(withIdentifier: GistCommentViewController.segueIdentifier, sender: self)
    }
}
