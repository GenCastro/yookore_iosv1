//
//  Addresses.swift
//  YKSIA
//
//  Created by Zwelithini Mathebula on 2016/02/19.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation

class Services {
    
    private var token :String!
    private var baseUrls:NSDictionary?
    init()
    {
        self.token = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI3NTI1NDlhZS0wNTMwLTRiMTYtYjU1Mi1kOGNlZTVmMmJhZWEiLCJzdWIiOiJpb3MtbW9iaWxlIiwiYXV0aG9yaXRpZXMiOlsidWFhLnJlc291cmNlIiwicGFzc3dvcmQud3JpdGUiLCJjbGllbnRzLnNlY3JldCJdLCJzY29wZSI6WyJwYXNzd29yZC53cml0ZSIsImNsaWVudHMuc2VjcmV0IiwidWFhLnJlc291cmNlIl0sImNsaWVudF9pZCI6Imlvcy1tb2JpbGUiLCJjaWQiOiJpb3MtbW9iaWxlIiwiYXpwIjoiaW9zLW1vYmlsZSIsImdyYW50X3R5cGUiOiJjbGllbnRfY3JlZGVudGlhbHMiLCJyZXZfc2lnIjoiNzBmMjU0NjYiLCJpYXQiOjE0NTU4OTI3MjMsImV4cCI6MTc3MTI1MjcyMywiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3VhYS9vYXV0aC90b2tlbiIsInppZCI6InVhYSIsImF1ZCI6WyJpb3MtbW9iaWxlIiwicGFzc3dvcmQiLCJjbGllbnRzIiwidWFhIl19.biaUVmoqMyCWJoRLtv3rxRDq7vR1eoB6gvyp4pmrzis"
        
        let path = NSBundle.mainBundle().pathForResource("Services", ofType: "plist")
        
        if path != "" || path != ""{
            
            let dic = NSDictionary(contentsOfFile: path!)
            baseUrls = dic?.valueForKey("baseUrls") as? NSDictionary
        }
        
    }
    
    internal func getToken() -> String
    {
        return token
    }
    
    
    internal func getUserAcc() ->String
    {
        return baseUrls!.valueForKey("UserAcc") as! String
    }
    internal func signUp() ->NSURL
    {
        return NSURL(string: getUserAcc()+"/v1/create-account")!
        
    }
    internal func login() ->NSURL
    {
//        let url:NSURL?
//        let strUrl:String = getBaseUrls().valueForKey("UserAcc") as! String + "/v1/authenticate"
//        
//        url = NSURL(string: strUrl)
//        
//        return url!
        return NSURL(string: getUserAcc()+"/v1/authenticate")!
    }
    
}