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
    
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var vwFb: FBSDKLoginButton!
    
    @IBAction func back(sender: UIBarButtonItem) {
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //indicator.stopAnimating()
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
    
    func sharedFunction(var code: Int,dic:AnyObject,funcName : String)
    {
        
        if funcName == "login"
        {
                if code == 200{
                    defer{
                    do
                    {
                   
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(dic as! NSData, options: []) as! NSDictionary
                        
                        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
                        appDel?.profile.userid = jsonResult.valueForKey("userid") as? String
                        
                        print("Access_Token -> \(jsonResult.valueForKey("access_token"))")
                        print("userid -> \(jsonResult.valueForKey("userid"))")
                        print("Fullname -> \(jsonResult.valueForKey("fullname"))")
                        print("email -> \(jsonResult.valueForKey("email"))")
                        
                        let checkUser = jsonResult.valueForKey("legacyuser") as! Bool
                        
                        if  checkUser == true
                        {
                            appDel = UIApplication.sharedApplication().delegate as? AppDelegate
                            
                            let auth = getB64Auth((appDel?.profile.username)!,password: (appDel?.profile.password)!)
                            
                            appDel?.httpRequest.makeGetRequest((appDel?.services.loginLegacyUser((appDel?.profile.username)!))!, objClass: "login", funcName: "legacyUser", extra: auth)
                            
                        }else
                        {
                            
                        }
                    }catch
                    {
                        
                    }
                    }

                    
                }else if code == 404
                {
                     print("\(code)")
                    
                    }
        }else if funcName == "legacyUser"
        {
            //change var
           code = 200
            if code == 200{
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("loginterms")
                    
                    let view = UIApplication.sharedApplication().keyWindow?.rootViewController
                    view!.presentViewController(nextViewController, animated:true, completion:nil)
                    
                })
               
                
//                do
//                {
//                    
////                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(dic as! NSData, options: []) as! NSDictionary
////                    print("Access_Token -> \(jsonResult.valueForKey("access_token"))")
////                    print("userid -> \(jsonResult.valueForKey("userid"))")
////                    print("Fullname -> \(jsonResult.valueForKey("fullname"))")
////                    print("email -> \(jsonResult.valueForKey("email"))")
//                    
//                    
//                }catch
//                {
//                    
//                }
                
                
                
            }else if code == 401
            {
                
                defer {
                    dispatch_async( dispatch_get_main_queue(), {
                        let alert = UIAlertController(title: "Password", message:"Oh Ooh! Incorrect password", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "I see", style: .Default) { _ in })
                        let view = UIApplication.sharedApplication().keyWindow?.rootViewController
                        view!.presentViewController(alert, animated: true){}
                        
                        });
                }
                
            }
            
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
