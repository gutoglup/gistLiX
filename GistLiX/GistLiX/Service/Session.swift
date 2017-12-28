//
//  Session.swift
//  GistLiX
//
//  Created by Augusto Reis on 24/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import Foundation
import Alamofire

class Session {
    
    // MARK: - Properties -
    
    private var manager : SessionManager?
    
    
    /// This method configure session manager of Alamofire,
    /// timeout request, and server trust policy.
    ///
    /// - Returns: Session Manager configured
    func apiManager() -> SessionManager{
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.urlCache = nil
        
        let serverTrustPolicy : [String: ServerTrustPolicy] = [
            "https://api.github.com" : .disableEvaluation
        ]
        
        
        self.manager = SessionManager(configuration: configuration, delegate: SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicy))
        
        self.manager?.delegate.sessionDidReceiveChallenge = { session, challenge in
            
            var disposition: URLSession.AuthChallengeDisposition = .useCredential
            var credential: URLCredential?
            
            print("received challenge")
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = self.manager?.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
        
        return self.manager!
    }
    
    
    
}




