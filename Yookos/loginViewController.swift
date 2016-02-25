//
//  loginViewController.swift
//  YKSIA
//
//  Created by Zwelithini Mathebula on 2016/02/18.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit


class LoginViewController : UIViewController {
    
     var appDel:AppDelegate?
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtUsername: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
    }
    
    /*
    
    
    */
    
    @IBAction func login(sender: AnyObject) {
        
        //let request = NSMutableURLRequest(URL: (appDel?.services?.login())!)
        
        let url = appDel?.services?.login()
        let json : [String: AnyObject] = [ "username"  : txtUsername.text!, "password" : txtPassword.text!]
        
        appDel?.profile.username = txtUsername.text
        appDel?.profile.password = txtPassword.text
        appDel?.httpRequest.makePostRequest(url!, body: json)
        
    }
    func sharedFunction(code: Int,dic:AnyObject) {
        
        print("called for this")
        
        
                if code == 200{
                    
                    let checkUser = dic.valueForKey("legacyuser") as! Bool
        
                    if  checkUser == true
                    {
                       appDel = UIApplication.sharedApplication().delegate as? AppDelegate
                    
                        _ = getB64Auth((appDel?.profile.username)!,password: (appDel?.profile.password)!)
                        
                    }else
                    {
                        
                    }
                }else if code == 404
                {
                     print("\(code)")
                    
                }

    }
    
    private func getB64Auth(username : String,password :String) -> String{
        
        let apiLoginString = NSString(format: "%@:%@", username, password)
        let apiLoginData = apiLoginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64ApiLoginString = apiLoginData.base64EncodedStringWithOptions([])
        print("\(base64ApiLoginString)")
        return base64ApiLoginString;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
