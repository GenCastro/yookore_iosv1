//
//  InviteSpace.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/31.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit
import AddressBook
import Contacts

class InviteSpace: UIViewController {
    
    
    
    @IBAction func back(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    @IBAction func findOnGmail(sender: AnyObject) {
        
        
        let alert = UIAlertController(title: "Gmail Friends", message: "we couldnt find any link to your gmail account", preferredStyle: .Alert)
        
        dispatch_async(dispatch_get_main_queue(), {
            UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
        })
        
    }
    @IBAction func findOnYmail(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Yahoo Friends", message: "we couldnt find any link to your yahoo account", preferredStyle: .Alert)
        
        dispatch_async(dispatch_get_main_queue(), {
            UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
        })
        
    }
    
    @IBAction func InviteFromContacts(sender: AnyObject) {
        
       Methods().getAllContacts()
        
        
        
    }
    @IBAction func skip(sender: AnyObject) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
