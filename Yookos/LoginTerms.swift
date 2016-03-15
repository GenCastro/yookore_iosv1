//
//  LoginTerms.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/11.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation


class LoginTerms: UIViewController
{
    
    @IBOutlet var webView: UIWebView!
    var appDel : AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.endEditing(true)
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        // Do any additional setup after loading the view, typically from a nib.
        let url = NSURL (string: "http://google.com")
        //let url = NSURL (string: "https://chat.yookos.com/files/assests/terms.html")
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doNotAgree(sender: AnyObject) {
        
         self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func agree(sender: AnyObject) {
        
        let url = appDel?.services?.updateLegacyPassword((appDel?.profile.userid)!)
        
        let json : [String: AnyObject] = [ "username"  : (appDel?.profile.username)! , "password" : (appDel?.profile.password)!]
        
        appDel?.httpRequest.makePutRequest(url!, body: json,objClass: "loginterms",funcName: "agree")
    }
    
    func receiveResponse(code: Int,dic:AnyObject,funcName : String)
    {
        
        if funcName == "agree"
        {
            if code == 200{
                
                print("PASSWORD UPDATED")
                //will then push to another screen
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("welcome2")
                
                let view = UIViewController.topMostController()
                view.presentViewController(nextViewController, animated:true, completion:nil)
                
            }else if code == 404
            {
                print("\(code)")
                
            }
            
        }
    }
}