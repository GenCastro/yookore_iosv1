//
//  Profile.swift
//  YKSIA
//
//  Created by Zwelithini Mathebula on 2016/02/19.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation


class Profile {
    
    var fullname :String? = ""
    var password:String? = ""
    var firstname:String? = ""
    var lastname:String? = ""
    var cellphone:String? = ""
    var email:String? = ""
    var homeCountry:String? = ""
    var birthdate:NSTimeInterval?
    var dateOfBirth:String? = ""
    var gender:String? = "Male"
    var terms : Bool = false
    var day : String? = ""
    var month : String? = ""
    var year : String? = ""
    var curCity = ""
    var homeCity = ""
    var currentcountry = ""
    var externalId: String?// optional
    var profileUrl:String?// optional
    var username:String? = "castrozest6EdjLAaAm" //optional
    
    var userid:String? = "21c4baa0-9db6-4c18-acf0-2c13ab62fa51"
    var access_token:String? = ""
    var refresh_token:String? = ""
    var token_expiry:Int64?
    var sessionID:String? = ""
    
    
    var nameVer : Bool? = false
    var lastnameVer:Bool? = false
    var emailMatch:Bool? = false
    var emailVer:Bool? = false
    
    var countryId = ""
    var homeCountryId = ""
    
    var schoolName = ""
    
}