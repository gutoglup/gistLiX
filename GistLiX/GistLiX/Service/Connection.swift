//
//  Connection.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireNetworkActivityIndicator
import SwiftyJSON

typealias handlerResponseJSON = (Alamofire.DataResponse<Any>) -> Swift.Void
typealias handlerResponseObject = (Any) -> Swift.Void
typealias handlerDownloadResponseData = (Alamofire.DownloadResponse<Data>) -> Swift.Void

class Connection {
    
    // MARK: - Properties -
    
    static let sharedConnection = Connection()
    
    var headers : HTTPHeaders?
    
    var dataHeaders : HTTPHeaders?
    
    var cookies = [HTTPCookie]()
    
    var stringCookies = ""
    
    // MARK: - Request Methods -
    
    /// Request Method
    ///
    /// - Parameters:
    ///   - url: Request link
    ///   - responseJSON: Handler to completion
    static func request(_ url : String, responseJSON: @escaping handlerResponseJSON) {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        let manager = Session().apiManager()
        
        manager.request(url).responseJSON { (response) in
            print("URL: \(url)\nJSON Response: \(response)")
            
            responseJSON(response)
        }
        
    }
    
    /// Request Method
    ///
    /// - Parameters:
    ///   - url: request link
    ///   - method: HTTP Method
    ///   - parameters: Dictionary representation
    ///   - dataResponseJSON: Handler to completion
    static func request(_ url : String, method : HTTPMethod, parameters : [String : Any]?, dataResponseJSON: @escaping handlerResponseJSON) {
        
        NetworkActivityIndicatorManager.shared.isEnabled = true
        let manager = Session().apiManager()
        manager.session.configuration.urlCache?.removeAllCachedResponses()
        
        if let userCredential = Authorizantion.userCredential {
            setHeadersAuthorization(with: userCredential)
        } else {
            setDefaltHeaders()
        }
        
        manager.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: Connection.sharedConnection.headers).responseJSON { (response) in
            
            Connection.getCookies(response: response)
            print("URL: \(url)\nJSON Response: \(response)\n")
            dataResponseJSON(response)
        }
        
    }
    
    
    /// Request Data Method
    ///
    /// - Parameters:
    ///   - url: Request link
    ///   - method: HTTP Method
    ///   - parameters: Dictionary representation
    ///   - dataResponse: Handler to completion
    static func requestData(_ url : String, method : HTTPMethod, parameters : [String : Any]?, dataResponse: @escaping (Data?) -> ()) {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        let manager = Session().apiManager()
        manager.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: Connection.sharedConnection.dataHeaders).responseJSON { (response) in
            print("URL: \(url)")
            
            dataResponse(response.data)
        }
        
    }
    
    static func getCookies(response : DataResponse<Any>) {
        if Connection.sharedConnection.cookies.count == 0 {
            if let headerFields = response.response?.allHeaderFields as? [String: String], let url = response.request?.url {
                Connection.sharedConnection.cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                
                Connection.sharedConnection.stringCookies = ""
                for cookie in Connection.sharedConnection.cookies {
                    Connection.sharedConnection.stringCookies += "\(cookie.name)=\(cookie.value);"
                }
            }
        }
    }
    
    /// Configure Default Headers
    static func setDefaltHeaders() {
        
        if Connection.sharedConnection.headers == nil {
            Connection.sharedConnection.headers = [:]
        }
        Connection.sharedConnection.headers?["Content-Type"] = "application/json"
        Connection.sharedConnection.headers?["Accept"] = "application/json;charset=UTF-8"
        
    }
    
    /// Configure User Token Acess
    ///
    /// - Parameter token: User Token
    static func setHeadersAuthorization(with credential : String) {
        if Connection.sharedConnection.headers == nil {
            Connection.sharedConnection.headers = [:]
        }
        Connection.sharedConnection.headers?["authorization"] = credential
        Connection.sharedConnection.headers?["Content-Type"] = "application/json"
        Connection.sharedConnection.headers?["Accept"] = "application/json;charset=UTF-8"
    }
    
    static func removeSession() {
        Connection.sharedConnection.headers = nil
    }
    
    
    
    
}


