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

    init()
    {
        login = LoginViewController.init()
        signup = SignUpViewController.init()
    }
    
    func requestFinished(code :Int ,dic: AnyObject,objClass : String,funcName : String)
    {
        if objClass == "login"
        {
            login.sharedFunction(code, dic: dic)
            
        }else if objClass == "signup"
        {
            signup.receiveRequest(code, response: dic, funcName: funcName)
        }
    }
    
}
