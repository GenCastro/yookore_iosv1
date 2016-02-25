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
    init()
    {
        login = LoginViewController.init()
    }
    
    func requestFinished(code :Int ,dic: AnyObject)
    {
        login.sharedFunction(code, dic: dic)
    }
}
