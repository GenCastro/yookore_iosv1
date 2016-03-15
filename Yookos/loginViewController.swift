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
    @IBOutlet var btnHaveProblem: UIButton!
    
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var vwFb: FBSDKLoginButton!
    
    @IBAction func back(sender: UIBarButtonItem) {
        
       dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.endEditing(true)
        //indicator.stopAnimating()
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        
        
        btnLogin?.layer.cornerRadius = 3
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
            print(error)
        }
        else if result.isCancelled {
            // Handle cancellations
            
            print("cancelled")
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                
                print(result.valueForKey("email"))
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
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
        
        
        if txtUsername.text == "" || txtPassword.text == ""
        {
            defer {
                dispatch_after( 1,dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Error!", message:"username and password can not be empty", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok!", style: .Default) { _ in })
                    
                    self.presentViewController(alert, animated: false,completion: nil)
                    
                });
            }
        }else
        {
            let url = appDel?.services?.login()
            let json : [String: AnyObject] = [ "username"  : txtUsername.text!, "password" : txtPassword.text!]
            
            appDel?.profile.username = txtUsername.text
            appDel?.profile.password = txtPassword.text
            appDel?.httpRequest.makePostRequest(url!, body: json,objClass: "login",funcName: "login")
        }
        
        
        
        
    }
    
    func sharedFunction( code: Int,dic:AnyObject,funcName : String)
    {
        
        if funcName == "login"
        {
                if code == 200{
                    
                    do
                    {
                   
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(dic as! NSData, options: []) as! NSDictionary
                        
                        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
                        appDel?.profile.userid = jsonResult.valueForKey("userid") as? String
                        
                        print("Access_Token -> \(jsonResult.valueForKey("access_token"))")
                        print("userid -> \(jsonResult.valueForKey("userid"))")
                        print("Fullname -> \(jsonResult.valueForKey("fullname"))")
                        print("email -> \(jsonResult.valueForKey("email"))")
                        
                        var checkUser = jsonResult.valueForKey("legacyuser") as! Bool
                        checkUser = true
                        if  checkUser == true
                        {
                            appDel = UIApplication.sharedApplication().delegate as? AppDelegate
                            
                            let auth = getB64Auth((appDel?.profile.username)!,password: (appDel?.profile.password)!)
                            
                            appDel?.httpRequest.makeGetRequest((appDel?.services.loginLegacyUser((appDel?.profile.username)!))!, objClass: "login", funcName: "legacyUser", extra: auth)
                            
                        }else
                        {
                            print("logged in")
                        }
                    }catch
                    {
                        
                    }
                    

                    
                }else if code == 404
                {
                     print("\(code)")
                    let alert = UIAlertController(title: "Error", message:"You have entered wrong login creditials,please enter again", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                    
                
                    dispatch_async( dispatch_get_main_queue(),{
                        
                        
                        let view = UIViewController.topMostController()
                        view.presentViewController(alert, animated: true,completion: nil)
                    })
                    
                }
        }else if funcName == "legacyUser"
        {
            
            if code == 200{
                
                dispatch_after(1,dispatch_get_main_queue(), { () -> Void in
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("loginterms")
                    
                    let view = UIViewController.topMostController()
                    view.presentViewController(nextViewController, animated:true, completion:nil)
                    
                })
                
                
            }else if code == 401
            {
                
                let alert = UIAlertController(title: "Error", message:"You have entered wrong login creditials,please enter again", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                
                dispatch_async( dispatch_get_main_queue(),{
                    self.presentViewController(alert, animated: true,completion: nil)
                })
                
            }
            
        }
    }
    @IBAction func forgotPassword(sender: AnyObject) {
        
        dispatch_after(1,dispatch_get_main_queue(), { () -> Void in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("requestPassword")
            
            self.presentViewController(nextViewController, animated:true, completion:nil)
            
        })
        
    }
    
    @IBAction func haveProblem(sender: AnyObject) {
        
        dispatch_after(1,dispatch_get_main_queue(), { () -> Void in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("help")
            
            self.presentViewController(nextViewController, animated:true, completion:nil)
            
        })
        
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
