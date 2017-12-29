//
//  ServiceModel.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias HandlerObject = (Any?) -> Swift.Void

// MARK: - Service Delegate -

protocol ServiceDelegate {
    
    
    /// Request service - GET
    /// This method use HTTP Method GET to send the request
    /// It's important the params can't send at HTTP Body because isn't conforms HTTP protocol
    ///
    /// - Parameters:
    ///   - _: Type of class for object to return information
    ///   - requestLink: Request link to server
    ///   - parameters: Dictionary representation of object to send
    ///   - handlerObject: Completion clousure
    func fetch<T:Model>(_:T.Type, requestLink : RequestLink, parameters: [String:String]?, handlerObject : @escaping HandlerObject)
    
    /// Request service - POST
    /// This method use HTTP Method POST to send the request
    ///
    /// - Parameters:
    ///   - _: Type of class for object to return information
    ///   - requestLink: Request link to server
    ///   - parameters: Dictionary representation of object to send
    ///   - handlerObject: Completion clousure
    func push<T:Model>(_:T.Type, requestLink: RequestLink, parameters: [String:String]?, handlerObject: @escaping HandlerObject)
    
    /// Request service - PUT
    /// This method use HTTP Method PUT to send the request
    ///
    /// - Parameters:
    ///   - _: Type of class for object to return information
    ///   - requestLink: Request link to server
    ///   - parameters: Dictionary representation of object to send
    ///   - handlerObject: Completion clousure
    func update<T:Model>(_:T.Type, requestLink: RequestLink, parameters: [String:String]?, handlerObject: @escaping HandlerObject)
    
    /// Request service - DELETE
    /// This method use HTTP Method DELETE to send the request
    ///
    /// - Parameters:
    ///   - _: Type of class for object to return information
    ///   - requestLink: Request link to server
    ///   - parameters: Dictionary representation of object to send
    ///   - handlerObject: Completion clousure
    func delete<T:Model>(_:T.Type, requestLink: RequestLink, parameters: [String:String]?, handlerObject: @escaping HandlerObject)
}

// MARK: - Service Model -

class ServiceModel : ServiceDelegate{
    
    // MARK: - File Names -
    private struct FileName {
        static let requestLink = "RequestLinks"
    }
    
    // MARK: - Properties -
    
    var url : String?
    var parameters : [String:Any]?
    
    // MARK: - Constructors -
    
    init() {
        
    }
    
    init(url : String?) {
        self.url = url
    }
    
    init(url : String?, parameters : [String:Any]?) {
        self.url = url
        self.parameters = parameters
    }
    
    // MARK: - Service Delegate Methods -
    
    func fetch<T:Model>(_:T.Type, requestLink : RequestLink, parameters: [String:String]?, handlerObject : @escaping HandlerObject) {
        
        var url = self.requestLink(type: requestLink)
        if let parameters = parameters {
            url = self.mapLink(url: url, parameters: parameters)
        }
        
        if !verifyConnection() {
            let error = ReachabilityError.notConnection
            handlerObject(error)
            return
        }
        
        Connection.request(url , method: .get, parameters: nil) { (dataResponse) in
            switch dataResponse.result {
            case .success:
                guard let array = dataResponse.result.value as? [Any] else {
                    handlerObject(T(json: JSON(dataResponse.result.value!)))
                    return
                }
                
                var arrayObject = [T]()
                for object in array {
                    arrayObject.append(T(json: JSON(object)))
                }
                
                handlerObject(arrayObject)
            case .failure:
                handlerObject(ReachabilityError.requestTimeout)
            }
        }
        
    }
    
    func push<T:Model>(_:T.Type, requestLink: RequestLink, parameters: [String:String]?, handlerObject: @escaping HandlerObject) {
        
        var url = self.requestLink(type: requestLink)
        if let parameters = parameters {
            url = self.mapLink(url: url, parameters: parameters)
        }
        
        if !verifyConnection() {
            let error = ReachabilityError.notConnection
            handlerObject(error)
            return
        }
        
        Connection.request(url, method: .post, parameters: parameters) { (dataResponse) in
            switch dataResponse.result {
            case .success:
                guard let array = dataResponse.result.value as? [Any] else {
                    handlerObject(T(json: JSON(dataResponse.result.value!)))
                    return
                }
                
                var arrayObject = [T]()
                for object in array {
                    arrayObject.append(T(json: JSON(object)))
                }
                
                handlerObject(arrayObject)
            case .failure:
                handlerObject(ReachabilityError.requestTimeout)
            }
        }
    }
    
    func update<T:Model>(_:T.Type,requestLink: RequestLink, parameters: [String:String]?, handlerObject: @escaping HandlerObject) {
        
        var url = self.requestLink(type: requestLink)
        if let parameters = parameters {
            url = self.mapLink(url: url, parameters: parameters)
        }
        
        if !verifyConnection() {
            let error = ReachabilityError.notConnection
            handlerObject(error)
            return
        }
        
        Connection.request(url, method: .put, parameters: parameters) { (dataResponse) in
            switch dataResponse.result {
            case .success:
                guard let array = dataResponse.result.value as? [Any] else {
                    handlerObject(T(json: JSON(dataResponse.result.value!)))
                    return
                }
                
                var arrayObject = [T]()
                for object in array {
                    arrayObject.append(T(json: JSON(object)))
                }
                
                handlerObject(arrayObject)
            case .failure:
                handlerObject(ReachabilityError.requestTimeout)
            }
        }
    }
    
    func delete<T:Model>(_:T.Type,requestLink: RequestLink, parameters: [String:String]?, handlerObject: @escaping HandlerObject) {
        
        var url = self.requestLink(type: requestLink)
        if let parameters = parameters {
            url = self.mapLink(url: url, parameters: parameters)
        }
        
        if !verifyConnection() {
            let error = ReachabilityError.notConnection
            handlerObject(error)
            return
        }
        
        Connection.request(url, method: .delete, parameters: parameters) { (dataResponse) in
            switch dataResponse.result {
            case .success:
                guard let array = dataResponse.result.value as? [Any] else {
                    handlerObject(T(json: JSON(dataResponse.result.value!)))
                    return
                }
                
                var arrayObject = [T]()
                for object in array {
                    arrayObject.append(T(json: JSON(object)))
                }
                
                handlerObject(arrayObject)
            case .failure:
                handlerObject(ReachabilityError.requestTimeout)
            }
        }
    }
    
    func verifyConnection() -> Bool{
        
        if let reachabilityNetwork = Alamofire.NetworkReachabilityManager(host: "www.google.com") {
            
            if reachabilityNetwork.isReachable {
                return true
            }
        }
        return false
        
    }
    
    // MARK: - File manager - Link requests -
    
    func requestLink(type:RequestLink) -> String{
        var link = ""
        link.append("https://api.github.com")
        link.append(keyManagerFile(key: type))
        return link
    }
    
    func keyManagerFile(key:Any) -> String{
        if  let key = key as? RequestLink{
            let file = FileManager.load(name: FileName.requestLink)
            if let link = file?.object(forKey: key.rawValue) as? String {
                return link
            }
        }
        return ""
    }
    
    func mapLink(url: String, parameters: [String: String]) -> String {
        var newUrl = url
        parameters.forEach { (key, value) in
            newUrl = newUrl.replacingOccurrences(of: "<\(key)>", with: value)
        }
        return newUrl
    }
    
}

// MARK: - Reachability Custom Error -

enum ReachabilityError : Error {
    case notConnection
    case requestTimeout
    
    func descriptionError() -> String {
        switch self {
        case .notConnection:
            return "CONNECTION_VERIFY"
        case .requestTimeout:
            return "REQUEST_TIMEOUT"
        }
    }
}




