//
//  VerificationView.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/16.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation

class VerificationView: UIViewController {
    
    @IBOutlet var lblEmail: UILabel!
    
    var appDel :AppDelegate?
    var count :Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        
        lblEmail.text = appDel?.profile.email
        count = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func resendVar(sender: AnyObject) {
        
        if count < 4
        {
            appDel = UIApplication.sharedApplication().delegate as? AppDelegate
            
            let json : [String: AnyObject] = [ "email"  : (appDel?.profile.email!)!, "userid" : (appDel?.profile.userid)!]
            
            appDel?.httpRequest.makePostRequest((appDel?.services.resendVerEmail())!, body: json, objClass: "verify", funcName: "verify")
        }else
        {
            let alert = UIAlertController(title: "Verification", message:"we have resend a verification link", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .Default) { _ in })
            
            dispatch_async( dispatch_get_main_queue(),{
                UIViewController.topMostController().presentViewController(alert, animated: true,completion: nil)
            })
        }
        
    }
    
    func receiveResponse(code :Int,dic:AnyObject)
    {
        if code == 200{
            
            count = count! + 1
            
            let alert = UIAlertController(title: "Verification", message:"we have resend a verification link", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .Default) { _ in })
            
            dispatch_async( dispatch_get_main_queue(),{
                UIViewController.topMostController().presentViewController(alert, animated: true,completion: nil)
            })

            
            
        }else
        {
            
            let alert = UIAlertController(title: "Error", message:"we have encountered an error with your request", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
            
            dispatch_async( dispatch_get_main_queue(),{
                UIViewController.topMostController().presentViewController(alert, animated: true,completion: nil)
            })
            
        }
    }
}