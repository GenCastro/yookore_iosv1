//
//  MyProtocol.swift
//  YKSIA
//
//  Created by Zwelithini Mathebula on 2016/02/22.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation

class MyProtocol {
    
    var login :LoginViewController
    var signup : SignUpViewController
    var signup2 : SignUpStepTwoView
    var loginTerms : LoginTerms
    var verify : VerificationView

    init()
    {
        login = LoginViewController.init()
        signup = SignUpViewController.init()
        signup2 = SignUpStepTwoView.init()
        loginTerms = LoginTerms.init()
        verify = VerificationView.init()
    }
    
    func postRequestFinished(code :Int ,dic: AnyObject,objClass : String,funcName : String)
    {
        if objClass == "login"
        {
           
                login.sharedFunction(code, dic: dic, funcName: funcName)
            
        }else if objClass == "signup"
        {
            signup.receiveRequest(code, response: dic, funcName: funcName)
        }else if objClass == "signup2"
        {
            signup2.receiveRequest(code, response: dic, funcName: funcName)
        }else if objClass == "verify"
        {
            verify.receiveResponse(code, dic: dic)
        }else if objClass == "appdel"
        {
            AppDelegate().receiveResponse(code, dic: dic, funcName: funcName)
        }
    }
    
    
    func getRequestFinished(code : Int,dic: AnyObject,objClass : String,funcName : String)
    {
        
        if objClass == "login"
        {
            login.sharedFunction(code, dic: dic,funcName: funcName)
        }
    }
    
    func putRequestFinished(code :Int ,dic: AnyObject,objClass : String,funcName : String)
    {
        if objClass == "loginterms"
        {
            loginTerms.receiveResponse(code, dic: dic, funcName: funcName)
            
        }
    }
    
    
    
}
