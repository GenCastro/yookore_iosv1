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
            
                let check = Methods().validateEmail(txtUsername.text!)
            
            let json :[String : AnyObject]
                if check == true
                {
                    json  = [ "email"  : txtUsername.text!, "password" : txtPassword.text!]
                }else
                {
                    json  = [ "username"  : txtUsername.text!, "password" : txtPassword.text!]
                }
            
                
                appDel?.profile.username = txtUsername.text
                appDel?.profile.email = txtPassword.text
                let request = appDel?.httpRequest.getRequest(url!, body: json,method: "POST")
                
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request!){ data, response, error in
                    
                    if let httpResponse = response as? NSHTTPURLResponse {
                        
                        let code = httpResponse.statusCode
                        print(code)
                        
                        if code == 200
                        {
                            do{
                                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data! , options: []) as! NSDictionary
                                
                                self.appDel = UIApplication.sharedApplication().delegate as? AppDelegate
                                
                                self.appDel?.profile.fullname = jsonResult.valueForKey("fullname") as? String
                                self.appDel?.profile.userid = jsonResult.valueForKey("userid") as? String
                                self.appDel?.profile.username = jsonResult.valueForKey("username") as? String
                                self.appDel?.profile.email = jsonResult.valueForKey("email") as? String
                                self.appDel?.profile.access_token = jsonResult.valueForKey("access_token") as? String
                                self.appDel?.profile.sessionID = jsonResult.valueForKey("sessionid") as? String
                                self.appDel?.profile.refresh_token = jsonResult.valueForKey("refresh_token") as? String
                                self.appDel?.profile.token_expiry = jsonResult.valueForKey("token_expiry") as? Int64
                                
                                
                                let checkUser = jsonResult.valueForKey("legacyuser") as! Bool
                                //checkUser = true
                                
                                if  checkUser == true
                                {
                                    self.appDel = UIApplication.sharedApplication().delegate as? AppDelegate
                                    
                                    
                                    let auth = self.getB64Auth(jsonResult.valueForKey("username") as! String, password: (self.appDel?.profile.password)!)
                                    
                                    let request = self.appDel?.httpRequest.getRequest((self.appDel?.services.loginLegacyUser((self.appDel?.profile.username)!))!,body: "",method: "GET")
                                    request!.addValue( "Basic " + auth, forHTTPHeaderField: "Authorization")
                                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request!){ data, response, error in
                                        
                                        if let httpResponse = response as? NSHTTPURLResponse {
                                            
                                            let code = httpResponse.statusCode
                                            
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
                                        }else
                                        {
                                            
                                        }
                                        
                                        if error != nil{
                                            
                                            print(error)
                                            return
                                        }
                                        
                                    }
                                    
                                    task.resume()
                                    
                                }else
                                {
                                    
                                    
                                    let verified = jsonResult.valueForKey("verified") as! Bool
                                    
                                    if (verified)
                                    {
                                        print("logged in")
                                        let alert = UIAlertController(title: self.appDel?.profile.fullname, message: self.appDel?.profile.username, preferredStyle: .Alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in
                                            
                                            self.txtUsername.text = self.appDel?.profile.username
                                            })
                                        
                                        dispatch_async( dispatch_get_main_queue(),{
                                            self.presentViewController(alert, animated: true,completion: nil)
                                        })
                                    }else
                                    {
                                        self.appDel = UIApplication.sharedApplication().delegate as? AppDelegate
                                        
                                        let json : [String: AnyObject] = [ "email"  : jsonResult.valueForKey("email")!, "userid" : jsonResult.valueForKey("userid")!]
                                   let request = self.appDel?.httpRequest.getRequest((self.appDel?.services.resendVerEmail())!, body: json,method: "POST")
                                        
                                        let task = NSURLSession.sharedSession().dataTaskWithRequest(request!){ data, response, error in
                                            
                                            if let httpResponse = response as? NSHTTPURLResponse {
                                                
                                                let code = httpResponse.statusCode
                                                
                                                if code == 200{
                                                    
                                                    
                                                    dispatch_after(1,dispatch_get_main_queue(), { () -> Void in
                                                        
                                                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                                        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("versignup")
                                                        
                                                        UIViewController.topMostController().presentViewController(nextViewController, animated:true, completion:nil)
                                                        
                                                    })
                                                    
                                                    
                                                }else
                                                {
                                                    
                                                    let alert = UIAlertController(title: "Error", message:"we have encountered an error with your request", preferredStyle: .Alert)
                                                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                                                    
                                                    dispatch_async( dispatch_get_main_queue(),{
                                                        UIViewController.topMostController().presentViewController(alert, animated: true,completion: nil)
                                                    })
                                                    
                                                }
                                                
                                            }else
                                            {
                                                
                                            }
                                            
                                            if error != nil{
                                                
                                                print(error)
                                                return
                                            }
                                            
                                        }
                                        
                                        task.resume()
                                    }
                                }
                                
                            }catch{
                                
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
                        
                        print(" passed 1" )
                        
                    }else
                    {
                        
                    }
                    
                    if error != nil{
                        
                        dispatch_async( dispatch_get_main_queue(),{
                            let alert = UIAlertController(title: "ERROR", message:"Network Connection Lost", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                            UIViewController.topMostController().presentViewController(alert, animated: true){}
                        })
                        return
                    }
                    
                }
                
                task.resume()
                
                
                
            }
            
        
        
        
        
        
    }
    
    
    
    @IBAction func forgotPassword(sender: AnyObject) {
        
        dispatch_after(1,dispatch_get_main_queue(), { () -> Void in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("requestPassword")
            
            UIViewController.topMostController().presentViewController(nextViewController, animated:true, completion:nil)
            
        })
        
    }
    
    @IBAction func haveProblem(sender: AnyObject) {
        
        dispatch_after(1,dispatch_get_main_queue(), { () -> Void in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("help")
            
            UIViewController.topMostController().presentViewController(nextViewController, animated:true, completion:nil)
            
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
