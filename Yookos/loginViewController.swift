//
//  loginViewController.swift
//  YKSIA
//
//  Created by Zwelithini Mathebula on 2016/02/18.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit


class LoginViewController : UIViewController,FBSDKLoginButtonDelegate{
    
     var appDel:AppDelegate?
    
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtUsername: UITextField!
    
    @IBOutlet var vwFb: FBSDKLoginButton!
    
    @IBAction func back(sender: UIBarButtonItem) {
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate

        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
    }
    
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
