//
//  Profile.swift
//  YKSIA
//
//  Created by Zwelithini Mathebula on 2016/02/19.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation


class Profile {
    
    var fullname :String?
    var password:String?
    var firstname:String?
    var lastname:String?
    var cellphone:String?
    var email:String?
    var currentcountry:String?
    var birthdate:NSTimeInterval?
    var dateOfBirth:String?
    var gender:String?
    var terms : Bool?
    var day : String?
    var month : String?
    var year : String?
    
    var externalId: String?// optional
    var profileUrl:String?// optional
    var username:String? //optional
    
    var userid:String?
    var access_token:String?
    var refresh_token:String?
    var token_expiry:Int64?
    var sessionID:String?
    
    
}