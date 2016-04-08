//
//  HobbiesNInterests.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/31.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class Hobbies: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate{
    
    @IBOutlet var btnNext: UIBarButtonItem!
    @IBOutlet var txtAdd: UITextField!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var vwTable: UIView!
    @IBOutlet var vwHobbiesAdded: UIView!
    
    
    var addedHobbies = NSMutableDictionary()
    var hobbies = NSMutableArray()
    var searchedHobbies = NSMutableArray()
    
    var yAxis : CGFloat = 0
    var xAxis : CGFloat = 0
    var ySpaceLeft :CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        vwTable.hidden = true
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        vwTable?.layer.borderWidth = 2
        vwTable?.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        vwTable?.layer.cornerRadius = 4
        
        let url = Services().interestsUrl()
        
        let request = HttpRequest().getRequest(url, body: [:], method: "GET")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data,response ,error in
        
            if let httpResponse = response! as? NSHTTPURLResponse
            {
                let code = httpResponse.statusCode
                print(code)
                if code == 200
                {
                    
                    do
                    {
                        let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSMutableArray
                       
                        self.hobbies = jsonData
                    }catch
                    {
                        print("couldnot convert to json")
                    }
                    
                }else
                {
                    print(response)
                }
            }else
            {
                return
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
        
        task.resume()
        
        self.tableView.delegate      =   self
        self.tableView.dataSource    =   self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ySpaceLeft = self.vwHobbiesAdded.frame.width
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addType(sender: UITextField) {
        
    
        
        
        let string = sender.text
        
        if string == "" {
            
            vwTable.hidden = true
            
        }else{
            
            searchedHobbies.removeAllObjects()
            for item in hobbies {
                
                if item.lowercaseString.hasPrefix(string!) {
                    
                    print("exists")
                    print(item)
                    searchedHobbies.addObject(item)
                }
                
            }
            
            if searchedHobbies.count > 0
            {
                tableView.reloadData()
                vwTable.hidden = false
            }
            
        }
        
        
        
        
        
        
    }
    
    @IBAction func next(sender: AnyObject) {
        
        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("popover")
        popoverVC?.view.backgroundColor = UIColor.clearColor()
        self.modalPresentationStyle = .Popover
        self.modalPresentationStyle = .OverFullScreen
        self.presentViewController(popoverVC!, animated: false, completion: nil)
        
        
        //let popoverController = popoverVC!.popoverPresentationController
        
        
        var addType = ""
        
        var hobsAdded = [String]()
        
        for item in addedHobbies {
            let hob = item.value as! NSMutableDictionary
            let selected = hob.valueForKey("selected") as! Bool
            
            if selected {
                
                hobsAdded.append(hob.valueForKey("name") as! String)
            }
        }
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        var request = NSURLRequest()
        if hobsAdded.count == 0 {
           
            let url = Services().addInterest(appDel.profile!.userid!, extra: addType)
            
            request = HttpRequest().getRequest(url, body: ["interest" : hobsAdded[0]], method: "POST")
            
        }else{
            
            addType = "multiple"
            let url = Services().addInterest(appDel.profile!.userid!, extra: addType)
            
             request = HttpRequest().getRequest(url, body: hobsAdded, method: "POST")
        }
        
        defer{
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    let code = httpResponse.statusCode
                    print(code)
                    
                    if code == 201 || code == 200
                    {
                       dispatch_async( dispatch_get_main_queue(),{
                        popoverVC!.dismissViewControllerAnimated(true, completion: {
                            
                            let next = self.storyboard?.instantiateViewControllerWithIdentifier("login")
                            
                            UIViewController.topMostController().presentViewController(next!, animated: true, completion: nil)
                           
                        })
                        
                        })
                    
                    }else
                    {
                        dispatch_async( dispatch_get_main_queue(),{
                        popoverVC!.dismissViewControllerAnimated(true, completion: {
                            
                            
                                let alert = UIAlertController(title: "ERROR", message:"We have encountered an error,please try again", preferredStyle: .Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                                UIViewController.topMostController().presentViewController(alert, animated: true){}
                            })
                        })
                    }
                    
                    
                    
                }else
                {
                    print("request not made")
                }
                
                if error != nil{
                    
                    print(error)
                    
                    dispatch_async( dispatch_get_main_queue(),{
                        popoverVC!.dismissViewControllerAnimated(true, completion: {
                        let alert = UIAlertController(title: "ERROR", message:"No Network Connection", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                        UIViewController.topMostController().presentViewController(alert, animated: true){}
                    })
                        })
                    return
                }
                
            }
            
            task.resume()
            
            print("task done")}
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchedHobbies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.searchedHobbies.objectAtIndex(indexPath.row) as? String
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        
        let text = searchedHobbies.objectAtIndex(indexPath.row) as! String
        hobbies.objectAtIndex(hobbies.indexOfObject(searchedHobbies.objectAtIndex(indexPath.row)))
        
        var found = false
        var key = ""
        for x in addedHobbies {
            
            let hob = x.value as! NSMutableDictionary
            let name = hob.valueForKey("name") as! String
            
            if name == text
            {
                found = true
                key = x.key as! String
                hob.setValue(true, forKey: "selected")
                addedHobbies.setValue(hob, forKey: key)
                break
            }
            
        }
        
        if found == true
        {
            let lbls = self.vwHobbiesAdded.subviews
            let lbl = lbls[Int(key)!] as! UILabel
            lbl.layer.backgroundColor = Color().tokenColor().CGColor
            lbl.textColor = UIColor.blackColor()
            
        }else
        {
            
            let lblHobby = UILabel()
            let hobby = NSMutableDictionary()
            
            hobby.setValue(true, forKey: "selected")
            hobby.setValue(text, forKey: "name")
            let tag = addedHobbies.count
            addedHobbies.setValue(hobby, forKey: String(tag))
            
            lblHobby.tag = tag
            
            lblHobby.numberOfLines = 0
            
            lblHobby.FAIcon = FAType.FAGithub
            lblHobby.setFAIcon(FAType.FAGithub, iconSize: 17)
            lblHobby.setFAText(prefixText: text+"  ", icon: FAType.FARemove, postfixText: "", size: 16)
            lblHobby.font = lblHobby.font.fontWithSize(24)
            lblHobby.frame.origin.x = xAxis
            lblHobby.sizeToFit()
            lblHobby.textAlignment = NSTextAlignment.Center
            lblHobby.font = lblHobby.font.fontWithSize(16)
            
            lblHobby.layer.backgroundColor = Color().tokenColor().CGColor
            
            lblHobby.layer.cornerRadius = 8
            
            let spaceAvailable = ySpaceLeft - xAxis
            
            if spaceAvailable < 0 {
                
                yAxis += lblHobby.frame.height + 8
                xAxis = 0
                lblHobby.frame.origin.x = xAxis
                ySpaceLeft = self.vwHobbiesAdded.frame.width
            }
            
            lblHobby.frame.origin.y = yAxis
            xAxis += lblHobby.frame.width + 4
            //print("X position -> \(self.lblWidth.frame.origin.x)")
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(Hobbies.tokenTap(_:)))
            lblHobby.addGestureRecognizer(tap)
            lblHobby.userInteractionEnabled = true
            
            
            vwHobbiesAdded.addSubview(lblHobby)
            ySpaceLeft = ySpaceLeft - xAxis
        }
        
        
        checkAdded()
        txtAdd.text = ""
        vwTable.hidden = true
        
        
    }
    
    func tokenTap(sender: UITapGestureRecognizer!) {
        
        let lbl = sender.view as? UILabel
        let hobby = addedHobbies.valueForKey(String(sender.view!.tag)) as? NSDictionary
        
        let selected = (hobby?.valueForKey("selected"))! as! Bool
        print(selected)
        if selected == false {
            
            hobby?.setValue(true, forKey: "selected")
            lbl!.layer.backgroundColor = Color().tokenColor().CGColor
            lbl!.textColor = UIColor.blackColor()
        }else
        {
            hobby?.setValue(false, forKey: "selected")
            lbl!.layer.backgroundColor = Color().tokenColor().CGColor
            lbl!.textColor = UIColor.lightTextColor()
        }
        
        
        addedHobbies.setValue(hobby, forKey: String(sender.view!.tag))
        checkAdded()
        print(addedHobbies.valueForKey(String(sender.view!.tag)))
        
        
    }
    
    func checkAdded() {
        
        var check = false
        
        for item in addedHobbies {
            let hob = item.value as! NSMutableDictionary
            let selected = hob.valueForKey("selected") as! Bool
            
            if selected {
                check = true
                break
            }
        }
        
        self.btnNext.enabled = check
    }
    
    
    
}
