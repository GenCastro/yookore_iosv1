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
    
    
    @IBAction func back(sender: UIBarButtonItem) {
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    /*
    
    
    */
    
    @IBAction func login(sender: AnyObject) {
        
        //let request = NSMutableURLRequest(URL: (appDel?.services?.login())!)
        
        let url = appDel?.services?.login()
        let json : [String: AnyObject] = [ "username"  : txtUsername.text!, "password" : txtPassword.text!]
        
        appDel?.profile.username = txtUsername.text
        appDel?.profile.password = txtPassword.text
        appDel?.httpRequest.makePostRequest(url!, body: json,objClass: "login",funcName: "login")
        
    }
    
    func sharedFunction(code: Int,dic:AnyObject)
    {
                if code == 200{
                    
                    do
                    {
                   
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(dic as! NSData, options: []) as! NSDictionary
                        print("Access_Token -> \(jsonResult.valueForKey("access_token"))")
                        print("userid -> \(jsonResult.valueForKey("userid"))")
                        print("Fullname -> \(jsonResult.valueForKey("fullname"))")
                        print("email -> \(jsonResult.valueForKey("email"))")
                        
                        let checkUser = jsonResult.valueForKey("legacyuser") as! Bool
                        
                        if  checkUser == true
                        {
                            appDel = UIApplication.sharedApplication().delegate as? AppDelegate
                            
                            _ = getB64Auth((appDel?.profile.username)!,password: (appDel?.profile.password)!)
                            
                        }else
                        {
                            
                        }
                    }catch
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
