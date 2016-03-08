//
//  User.swift
//  YKSIA
//
//  Created by Zwelithini Mathebula on 2016/02/19.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation

class User {
    
    var sessionid:String = ""
    var username:String = ""
    var userid:String = ""
    var message:String = ""
    var legacyuser:Bool = false
    var currentCountry :String = ""
    var currentState : String = ""
    var currentCity : String = ""
    
    init()
    {
        
            self.sessionid = ""
            self.username = ""
            self.userid = ""
            self.message = ""
            self.legacyuser = false
            self.currentCity = ""
            self.currentCountry = ""
            self.currentState = ""
    }
    
}