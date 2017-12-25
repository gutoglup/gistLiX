//
//  GistCells.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit

class GistUserCell: UITableViewCell, ReusableView {

    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var buttonComment: UIButton!
    
    
}

class GistDescriptionCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var labelDescription: UILabel!
    
}

class GistCodeCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var labelCode: UILabel!
    
}
