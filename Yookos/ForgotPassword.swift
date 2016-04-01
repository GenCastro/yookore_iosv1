//
//  ForgotPassword.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/23.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit


class ForgotPassword: UIViewController {
    
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func submit(sender: AnyObject) {
        
        print(txtEmail.text)
        
        let json : [String: AnyObject] = [ "email"  : txtEmail.text!,"context" : "passwordreset"]
        let request = HttpRequest().getRequest(Services().verifyEmail(), body: json ,method: "POST")
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                
                let code = httpResponse.statusCode
                print(code)
                
                if code == 200
                {
                    
                    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDel.profile.email = self.txtEmail.text
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("fpwd2");
                    dispatch_async(dispatch_get_main_queue(), {
                        //Code that presents or dismisses a view controller here
                        
                        self.presentViewController(nextViewController, animated:true, completion:nil)
                    });
                    
                    
                }else
                {
                    dispatch_async( dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "ERROR!", message:"Invalid email.Make sure we have the email you used.please enter again", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                        UIViewController.topMostController().presentViewController(alert, animated: true){}
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
        
        
        print("task done")
        
        
        
        
    }
    
    @IBAction func back(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}