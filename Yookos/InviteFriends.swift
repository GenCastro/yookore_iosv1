//
//  InviteFriends.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/31.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class InviteFriends: UITableViewController {
    
    var emails = [String]()
    var friendsOnYookos = NSMutableArray()
    var friendsNotOnYookos = NSMutableArray()
    var appDel = UIApplication.sharedApplication().delegate as? AppDelegate
    @IBOutlet var navVar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = Color().titleBarColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        self.tableView.registerNib(UINib(nibName: "AddFriendsCell", bundle: nil), forCellReuseIdentifier: "addfriendscell")
        
        let popoverVC = self.storyboard?.instantiateViewControllerWithIdentifier("popover")
        
        self.providesPresentationContextTransitionStyle = true;
        self.definesPresentationContext = true;
        self.presentViewController(popoverVC!, animated: false, completion: nil)
        
        let arrContacts = appDel?.extras.phoneContacts
        
        for index in 0 ..< arrContacts!.count {
            
            let dict = arrContacts![index] as! NSDictionary
            //print(dict.valueForKey("name"))
            let email = dict.valueForKey("email") as! NSArray
            emails.append(email[0] as! String)
            
        }
        
        if emails.count > 0
        {
            dispatch_async(dispatch_get_main_queue(), {
                
                let appDel = UIApplication.sharedApplication().delegate as? AppDelegate
                let url = Services().checkRelationship()
                print(url)
                let body:[String : AnyObject] = ["username" : (appDel?.profile.username)!,"email" : self.emails]
                print(body)
                let request = HttpRequest().getRequest(url, body: body, method: "POST")
                
                
                defer{
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            popoverVC?.dismissViewControllerAnimated(false, completion: {
                                if let httpResponse = response as? NSHTTPURLResponse {
                                    
                                    let code = httpResponse.statusCode
                                    print(code)
                                    
                                    if code == 200 || code == 201
                                    {
                                        do
                                        {
                                            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSMutableArray
                                            
                                            for item in jsonData!
                                            {
                                        
                                                let type = item.valueForKey("type") as! String
                                                let mail = item.valueForKey("email") as! String
                                                
                                                if type == "USER"
                                                {
                                                    var check = false
                                                    
                                                    for user in self.friendsOnYookos
                                                    {
                                                        let email = user.valueForKey("email") as! String
                                                        if mail == email
                                                        {
                                                            check = true
                                                            break
                                                        }
                                                        
                                                    }
                                                    
                                                    if check == false
                                                    {
                                                        self.friendsOnYookos.addObject(item)
                                                    }
                                                    
                                                   
                                                }else
                                                {
                                                    var check = false
                                                    
                                                    for user in self.friendsNotOnYookos
                                                    {
                                                        let email = user.valueForKey("email") as! String
                                                        if mail == email
                                                        {
                                                            check = true
                                                            break
                                                        }
                                                        
                                                    }
                                                    
                                                    if check == false
                                                    {
                                                        self.friendsNotOnYookos.addObject(item)
                                                    }
                                                    
                                                }
                                                
                                            }
                                            print("Number on yookos -> " + String(self.friendsOnYookos.count))
                                            print("Number not on yookos -> " + String(self.friendsNotOnYookos.count))
                                            
                                            self.tableView.reloadData()
                                        }catch
                                        {
                                            print("couldnot convert to json")
                                        }
                                    }else
                                    {
                                        
                                    }
                                    
                                    
                                    
                                }else
                                {
                                    
                                }
                                
                                if error != nil{
                                    
                                    dispatch_async( dispatch_get_main_queue(),{
                                        let alert = UIAlertController(title: "ERROR", message:"No Network Connection", preferredStyle: .Alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                                        UIViewController.topMostController().presentViewController(alert, animated: true){}
                                    })
                                    return
                                }
                            })
                        })
                    }
                    
                    task.resume()
                    
                    print("task done")}
                defer{
                    
                }
            })
            
        }else
        {
            
            
            let alert = UIAlertController(title: "Sorry!", message: "we could not get emails from your contacts", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            dispatch_async(dispatch_get_main_queue(), {
                popoverVC?.dismissViewControllerAnimated(false, completion: {
                    
                    UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
                    
                })
                
            })
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            let x = 2 + friendsOnYookos.count
            return x
        }
        
        if section == 1 {
            
            return friendsNotOnYookos.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        //cell.btnInvite.titleLabel?.text = "add"
        
        if indexPath.section == 0 {
            
            if indexPath.row > 1 {
               // cell = tableView.dequeueReusableCellWithIdentifier("addfriendscell", forIndexPath: indexPath) as! AddFriendsCell
        
                    let user = friendsOnYookos[indexPath.row] as! NSDictionary
                    _ = user.valueForKey("email") as! String
                    let  name = user.valueForKey("targetUsername") as! String
        
                    //cell.lblEmail.text = email
                    cell.textLabel!.text = name
                    //cell.btnInvite.titleLabel?.text = "Add"
                
            }else
            {
                cell.textLabel?.text = "Section -> "+String(indexPath.section)+" : row -> "+String(indexPath.row)
            }
            
            
            
        }
        else if indexPath.section == 1
        {
            //cell = tableView.dequeueReusableCellWithIdentifier("addfriendscell", forIndexPath: indexPath) as! AddFriendsCell
            
            //cell.btnInvite.titleLabel?.text = "Invite"
            
            //let user = friendsOnYookos[indexPath.row] as! NSDictionary
            //let email = user.valueForKey("email") as! String
            
//            for item in friendsNotOnYookos
//            {
//
//                
//                let email = item.valueForKey("email") as! String
//                
//                let arrContacts = appDel?.extras.phoneContacts
//                for index in 0 ..< arrContacts!.count {
//                    
//                    let dict = arrContacts![index] as! NSDictionary
//                    
//                    let mail = dict.valueForKey("email") as! NSArray
//                    if mail[0] as! String == email
//                    {
//                        cell.lblName.text = dict.valueForKey("name") as? String
//                        break
//                    }
//                    
//                }
//
//            }
            //cell.lblEmail.text = email
            
            cell.textLabel?.text = "Section -> "+String(indexPath.section)+" : row -> "+String(indexPath.row)
        }
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
    }
    
    
    
    
    
}
