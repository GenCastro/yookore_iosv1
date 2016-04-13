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
    
    /*888888888888888888888888888888888888888888888888888888888888888888888
     
     BASE URLS
     
     88888888888888888888888888888888888888888888888888888888888888888888*/
    
    internal func getToken() -> String
    {
        return token
    }
    
    private func getUserAcc() ->String
    {
        return baseUrls!.valueForKey("uas") as! String
    }
    
    private func getUpm() ->String
    {
        return baseUrls!.valueForKey("upm") as! String
    }
    
    private func getCountryUrl() -> String
    {
        return baseUrls?.valueForKey("countryUrls") as! String
    }
    
    private func getSocialUrl() -> String
    {
        return baseUrls?.valueForKey("socialgraph") as! String
    }
    
    /*888888888888888888888888888888888888888888888888888888888888888888888
 
                            UAS URLS
 
     88888888888888888888888888888888888888888888888888888888888888888888*/
    
    internal func signUp() ->NSURL
    {
        return NSURL(string: getUserAcc()+"/v1/create-account")!
        
    }
    internal func verifyUser() ->NSURL
    {
        return NSURL(string: getUserAcc()+"/v1/verifyuser")!
        
    }
    internal func verifyEmail() ->NSURL
    {
        return NSURL(string: getUserAcc()+"/v1/verifyemail")!
        
    }
    internal func resendVerEmail() ->NSURL
    {
        return NSURL(string: getUserAcc()+"/v1/reverifyuser")!
        
    }
    
    internal func login() ->NSURL
    {
        return NSURL(string: getUserAcc()+"/v1/authenticate")!
    }

    internal func help() ->NSURL
    {
        return NSURL(string: getUserAcc()+"/v1/help/create/")!
    }
    
    internal func updateLegacyPassword(userid : String) ->NSURL
    {
        return NSURL(string: getUserAcc()+"/v1/password/legacy/"+userid)!
    }
    internal func resetPassword(userid : String) ->NSURL
    {
        return NSURL(string: getUserAcc()+"/v1/password/reset/"+userid)!
    }
    
    
    
    /*888888888888888888888888888888888888888888888888888888888888888888888
     
     Countriees URLS
     
     88888888888888888888888888888888888888888888888888888888888888888888*/
    
    internal func countriesUrl() -> NSURL
    {
        return NSURL(string: getCountryUrl()+"countries")!
    }
    
    internal func getCities(id:String,name:String) -> NSURL
    {
        return NSURL(string: getCountryUrl()+"countries/" + id + "/cities/" + name)!
    }
    
    /*888888888888888888888888888888888888888888888888888888888888888888888
     
     UPM URLS
     
     88888888888888888888888888888888888888888888888888888888888888888888*/
    
    internal func interestsUrl() -> NSURL
    {
        return NSURL(string: getUpm()+"/api/v1/profile/interest/all")!
    }
    
    internal func addInterest(userid:String,extra:String?) ->NSURL
    {
        
        return NSURL(string: getUpm()+"/api/v1/profile/"+userid+"/interest/"+extra!)!
    }
    
    internal func updateProfile(username:String) ->NSURL
    {
        
        return NSURL(string: getUpm()+"/api/v1/profile/"+username)!
    }
    
    internal func addeducation(userid:String) ->NSURL
    {
        
        return NSURL(string: getUpm()+"/api/v1/profile/"+userid+"/education")!
    }
    /*888888888888888888888888888888888888888888888888888888888888888888888
     
     EXTRAS USES URLS
     
     88888888888888888888888888888888888888888888888888888888888888888888*/
    
    
    internal func validateEmail() ->NSURL
    {
        return NSURL(string: "http://helper-suite.apps.yookosapps.com/v1/validate-email")!
    }
    internal func loginLegacyUser(username : String) ->NSURL
    {
        return NSURL(string: "http://www.yookos.co.uk/api/core/v3/people/username/" + username+"/")!
    }
    
    /*888888888888888888888888888888888888888888888888888888888888888888888
     
     SOCIAL GRAPH URLS
     
     88888888888888888888888888888888888888888888888888888888888888888888*/
    
    internal func checkRelationship() -> NSURL
    {
        return NSURL(string: getSocialUrl()+"/api/v1/friends/status")!
    }
    
}