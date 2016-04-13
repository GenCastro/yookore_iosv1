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
        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
        dispatch_async(dispatch_get_main_queue(), {
            UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
        })
        
    }
    @IBAction func findOnYmail(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Yahoo Friends", message: "we couldnt find any link to your yahoo account", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
        dispatch_async(dispatch_get_main_queue(), {
            UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
        })
        
    }
    
    @IBAction func InviteFromContacts(sender: AnyObject) {
        
        let status = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts) as CNAuthorizationStatus
        let arrContacts = NSMutableArray()
        if status == CNAuthorizationStatus.Denied {
            
            let alert = UIAlertController(title:nil, message:"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can use contacts", preferredStyle:UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler:nil))
            UIViewController.topMostController().presentViewController(alert, animated:true, completion:nil)
            return
        }
        
        let store = CNContactStore()
        store.requestAccessForEntityType(CNEntityType.Contacts) { (granted:Bool, error:NSError?) -> Void in
            
            if !granted {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // user didn't grant access;
                    // so, again, tell user here why app needs permissions in order  to do it's job;
                    // this is dispatched to the main queue because this request could be running on background thread
                })
                return
            }
            
            // Declare this array globally, so you can access it in whole class.
            
            let popoverVC = self.storyboard?.instantiateViewControllerWithIdentifier("popover")
            
            self.providesPresentationContextTransitionStyle = true;
            self.definesPresentationContext = true;
            self.presentViewController(popoverVC!, animated: false, completion: nil)
            
            let request = CNContactFetchRequest(keysToFetch:[CNContactIdentifierKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactFormatter.descriptorForRequiredKeysForStyle(CNContactFormatterStyle.FullName)])
            
            
            do {
                
                try store.enumerateContactsWithFetchRequest(request, usingBlock: { (contact:CNContact, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                    
                    let arrEmail = contact.emailAddresses as NSArray
                    var emails = [String]()
                    if arrEmail.count > 0 {
                        
                        let dict = NSMutableDictionary()
                        dict.setValue((contact.givenName+" "+contact.familyName), forKey: "name")
                       
                        
                        for x in 0  ..< arrEmail.count  {
                            
                            let email:CNLabeledValue = arrEmail.objectAtIndex(x) as! CNLabeledValue
                            emails.append(email.value as! String)
                            
                        }
                        dict.setValue(emails, forKey: "email")
                        arrContacts.addObject(dict) // Either retrieve only those contact who have email and store only name and email
                        
                    }
                    //arrContacts.addObject(contact) // either store all contact with all detail and simplifies later on
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        popoverVC?.dismissViewControllerAnimated(false, completion: {
                        
                            if arrContacts.count > 0
                            {
                                let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
                                appDel.extras.phoneContacts = arrContacts
                                
                                let next = self.storyboard?.instantiateViewControllerWithIdentifier("addfriends")
                                dispatch_async(dispatch_get_main_queue(), {
                                
                                    self.presentViewController(next!, animated: true, completion: nil)
                                })
                                
                                
                            }else
                            {
                                dispatch_async(dispatch_get_main_queue(), {
                                
                                    let alert = UIAlertController(title: "Ooops", message: "There seem to be no contacts on your device", preferredStyle: .Alert)
                                    alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                })
                            }
                        
                        
                            })
                        
                    
                    })
                    
                    
                })
            }catch {
                
                return
            }
        }
        return
        
        
        
    }
    @IBAction func skip(sender: AnyObject) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
