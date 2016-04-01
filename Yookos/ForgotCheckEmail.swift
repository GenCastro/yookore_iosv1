//
//  ForgotCheckEmail.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/24.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class ForgotCheckEmail: UIViewController,UIGestureRecognizerDelegate {
    
    
   
    @IBOutlet var lblEmail: UILabel!
    
    @IBOutlet var vwError: UIView!
    @IBOutlet var lblResend: UILabel!
    @IBOutlet var vwContent: UIView!
    var count : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
         let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        lblEmail.text = appDel.profile.email
        let tap = UITapGestureRecognizer(target: self, action: Selector("resend:"))
        lblResend!.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func resend(sender: UITapGestureRecognizer? = nil) {
        
        if count < 3
        {
            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let json : [String: AnyObject] = [ "email"  : appDel.profile.email!,"context" : "passwordreset"]
            let request = HttpRequest().getRequest(Services().verifyEmail(), body: json,method: "POST")
            
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    let code = httpResponse.statusCode
                    print(code)
                    
                    if code == 200
                    {
                        self.count += 1
                        
                      
                            dispatch_async( dispatch_get_main_queue(),{
                                let alert = UIAlertController(title: "Password link sent", message:"Please check your email address", preferredStyle: .Alert)
                                alert.addAction(UIAlertAction(title: "DISMISS", style: .Default) { _ in })
                                UIViewController.topMostController().presentViewController(alert, animated: true){}
                            })
                        
                        
                        
                    }else
                    {
                        
                    }
                    
                    print(" passed 1" )
                    
                }else
                {
                    
                }
                
                if error != nil{
                    
                    dispatch_async( dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "Error", message:"Network Connection lost", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                        UIViewController.topMostController().presentViewController(alert, animated: true){}
                    })
                    return
                }
                
            }
            
            task.resume()
            
            
            print("task done")
            
        }else
        {
            
            let xPosition = self.vwContent.frame.origin.x
            
            //View will slide 20px up
            let yPosition = self.vwContent.frame.origin.y + vwError.frame.height
            
            let height = self.vwContent.frame.size.height
            let width = self.vwContent.frame.size.width
            
            UIView.animateWithDuration(1.0, animations: {
                
                self.vwContent.frame = CGRectMake(xPosition, yPosition, height, width)
                
            })
            lblResend.enabled = false
            lblResend.textColor = UIColor.grayColor()
            
            
        }
        
    }
    @IBAction func help(sender: AnyObject) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("help");
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
}
