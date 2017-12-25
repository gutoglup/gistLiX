//
//  GenericExtensions.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit

protocol ReusableView : class { }

extension ReusableView where Self:UIView {
    static var reuseIdentifier : String {
        return String(describing:self)
    }
}

protocol ReusableSegueIdentifier : class { }

extension ReusableSegueIdentifier where Self:UIViewController {
    static var segueIdentifier : String {
        return String(describing:self)
    }
}

extension UIViewController : ReusableSegueIdentifier {
    
}

extension UITableView {
    
    
    /// Método de dequeueReusableCell
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: dequeue da célula
    func dequeueReusableCell<T:UITableViewCell>(forIndexPath indexPath:IndexPath)->T where T: ReusableView{
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    
    /// Método de dequeueReusableHeaderFooter
    ///
    /// - Returns: dequeue da header ou footer
    func dequeueReusableHeaderFooter<T:UITableViewHeaderFooterView>()->T where T:ReusableView {
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue header/footer with identifier \(T.reuseIdentifier))")
        }
        return headerFooter
    }
    
    
    /// Método de registro de header ou footer
    ///
    /// - Parameter _: tipo da header ou footer
    func registerHeaderFooter<T:UITableViewHeaderFooterView>(_:T.Type) where T:ReusableView {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    
}
