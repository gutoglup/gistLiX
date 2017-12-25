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
        var requestURL = url
        var encodingType : ParameterEncoding = JSONEncoding.default
        
//        if let token = ServiceHandler.shared.oAuth2.accessToken {
//            setHeadersAuthorization(with: token)
//        } else
//        if requestURL.contains(RequestLink.token.rawValue) {
//            setOAuth2Header()
//            requestURL = setOAuth2URL(url: requestURL)
//            encodingType = URLEncoding.default
//        } else {
            setDefaltHeaders()
//        }
        
        manager.request(requestURL, method: method, parameters: parameters, encoding: encodingType, headers: Connection.sharedConnection.headers).responseJSON { (response) in
            
            Connection.getCookies(response: response)
            
            print("URL: \(requestURL)\nJSON Response: \(response)\n")
            
            
            if response.response?.statusCode == 403 {
                NotificationCenter.default.post(name: NSNotification.Name.init("expiredSessionObserver"), object: nil)
            }
            
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
    
    // Request Image Method
    //
    // - Parameters:
    //   - url: Request link
    //   - imageResponse: Handler to completion
//    static func requestImage(_ url : String, imageResponse: @escaping handlerResponseImage) {
//
//        let manager = Session().apiManager()
//        manager.request(url).responseImage { response in
//            imageResponse(response)
//        }
//
//    }
    
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
    
    
    /// Configure Header to authentication
//    static func setOAuth2Header() {
//        let headers = [
//            "content-type": "application/x-www-form-urlencoded",
//            "authorization": OAuth2.KeysOAuth2.basicAuth,
//            "grant_type": OAuth2.KeysOAuth2.grantType
//        ]
//
//        Connection.sharedConnection.headers = headers
//    }
//
//    static func setOAuth2URL(url: String) -> String {
//        return url.remove(string: "/voucher")
//    }
    
    /// Configure User Token Acess
    ///
    /// - Parameter token: User Token
    static func setHeadersAuthorization(with token : String) {
        let headers = [
            "acess_token": token,
            "Content-Type": "application/json"//,
        ]
        
        Connection.sharedConnection.headers = headers
    }
    
    static func removeSession() {
        Connection.sharedConnection.headers = nil
    }
    
    
    
    
}


