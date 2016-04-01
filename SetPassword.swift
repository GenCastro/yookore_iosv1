//
//  SetPassword.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/24.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class SetPassword: UIViewController {
    
    
    @IBOutlet var txtpassword: UITextField!
    
    @IBOutlet var txtConfrim: UITextField!
    @IBOutlet var btnSave: UIButton!
    
    var verPassword:Bool = false
    var passMatch:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verPassword = false
        passMatch = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func verPassword(sender: UITextField) {
        
        print("typed")
        let txt = sender.text
        
        if txt?.characters.count < 6
        {
            verPassword = false
            return
        }
            let result = Methods().checkTextSufficientComplexity(txt!)
            verPassword = result
            print(result)
            if result == true
            {
                confirm()
                print("password match ->\(passMatch)")
            }
        
    }
    func confirm()
    {
        passMatch = false
        if self.txtConfrim.text == self.txtpassword.text
        {
            passMatch = true
        }
    }
    @IBAction func confirmPaswd(sender: UITextField) {
        
        confirm()
    }
    @IBAction func save(sender: UIButton) {
        
        if verPassword != true
        {
                defer {
                    dispatch_async( dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "Password", message:"Please enter password with at least one capital letter, a number and a minimum of six characters", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                        UIViewController.topMostController().presentViewController(alert, animated: true){}
                    })
                }
            
            return
        }
         print("password true")
        if passMatch != true
        {
            defer {
                dispatch_async( dispatch_get_main_queue(),{
                    let alert = UIAlertController(title: "Password", message:"The passwords entered do not match.Please enter password again", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                    UIViewController.topMostController().presentViewController(alert, animated: true){}
                })
            }
            
            return
        }
        
        
        print("password match")
        let json : [String: AnyObject] = [ "email"  : "mathebulazc@gmail.com","password" : txtpassword.text!]
        let request = HttpRequest().getRequest(Services().resetPassword("21c4baa0-9db6-4c18-acf0-2c13ab62fa51"), body: json,method: "POST" )
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                
                let code = httpResponse.statusCode
                print(code)
                
                if code == 200
                {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("setpwd2");
                    dispatch_async(dispatch_get_main_queue(), {
                        //Code that presents or dismisses a view controller here
                        self.presentViewController(nextViewController, animated:true, completion:nil)
                    });
                    
                    
                }else
                {
                    dispatch_async( dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "ERROR!", message:"We couldnot complete the request please try again or contact help centre", preferredStyle: .Alert)
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
    
    
    
    
}
