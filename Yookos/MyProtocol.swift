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
    
    
    
}
