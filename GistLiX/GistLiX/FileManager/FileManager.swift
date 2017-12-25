//
//  FileManager.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import Foundation

class FileManager {
    
    /// Load file to dictionary.
    /// The file needs extension .plist
    ///
    /// - Parameter name: File name
    /// - Returns: Dictionary of file
    static func load(name: String) -> NSMutableDictionary?{
        if let bundle = Bundle.main.path(forResource: name, ofType: "plist") {
            let file = NSMutableDictionary(contentsOfFile: bundle)
            return file
        }
        return nil
    }
}
