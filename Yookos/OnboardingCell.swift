//
//  OnboardingLocationCellTableViewCell.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/09.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class OnboardingCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet var lblCurCountry: UILabel?
    @IBOutlet var lblHomeCountry: UILabel!
    
    @IBOutlet var lblSkulType: UILabel!
    @IBOutlet var lblYearTo: UILabel!
    @IBOutlet var lblYearFrom: UILabel!
    @IBOutlet var txtSkulName: UITextField!
    @IBOutlet var vwCurCountry: UIView!
    @IBOutlet var vwHomeCountry: UIView!

    @IBOutlet var vwSkulType: UIView!
    @IBOutlet var vwFrmYr: UIView!
    @IBOutlet var vwToYr: UIView!
        
    @IBOutlet var tableview: UITableView?
    @IBOutlet var homeCityTable: UITableView!
    
    @IBOutlet var txtCurCity: UITextField!
    
    @IBOutlet var txtHomeCity: UITextField!
    var appdel = UIApplication.sharedApplication().delegate as? AppDelegate

    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        tableview?.dataSource = self
        tableview?.delegate = self
        tableview?.separatorStyle = UITableViewCellSeparatorStyle.None
        tableview?.layer.borderWidth = 2
        tableview?.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        tableview?.layer.cornerRadius = 4
        
        homeCityTable?.dataSource = self
        homeCityTable?.delegate = self
        homeCityTable?.separatorStyle = UITableViewCellSeparatorStyle.None
        homeCityTable?.layer.borderWidth = 2
        homeCityTable?.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        homeCityTable?.layer.cornerRadius = 4
    }
    
    @IBAction func schoolName(sender: UITextField) {
        
        if sender.text != "" {
            appdel?.profile.schoolName = sender.text!
        }
        
    }
    
    
    @IBAction func suggest(sender: UITextField) {
       
        
        let tag = sender.tag
        
        if tag == 1 {
            
            
            self.homeCityTable.hidden = true
            
            if txtCurCity.text?.characters.count > 2 {
                
                getCities(tag,id:(appdel?.profile.countryId)!, text: txtCurCity.text!)
            }
        }else if tag == 2
        {
            self.tableview?.hidden = true
            if txtHomeCity.text?.characters.count > 2 {
                
                if appdel?.profile.homeCountryId == ""
                {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let alert = UIAlertController(title: "Home Country", message: "please select your home country first", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
                    })
                    
                    return
                }else{
                    
                    getCities(tag,id:(appdel?.profile.homeCountryId)!, text: txtHomeCity.text!)
                }
                
            }
        }
        
        
        
    }
    
    func getCities(tag:Int,id:String,text:String)
    {
        
        var cities = [String]()
        let url =
            Services().getCities(id, name: text)
        let request = HttpRequest().getRequest(url, body: [:], method: "GET")
        
        defer{
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){data,response, error in
                
                if let httpResponse = response as? NSHTTPURLResponse
                {
                    let code = httpResponse.statusCode
                    print(code)
                    if code == 200
                    {
                        
                        do
                        {
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSMutableArray
                            
                            for result in json
                            {
                                let city = result.valueForKey("city")
                                let name = city?.valueForKey("name") as? String
                                
                                cities.append(name!)
                                
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                if tag == 1
                                {
                                    self.appdel?.extras.cities = cities
                                    self.tableview?.reloadData()
                                    self.tableview?.hidden = false
                                    self.txtCurCity.enabled = true
                                    self.txtCurCity.becomeFirstResponder()
                                    
                                    
                                    
                                }else if tag == 2
                                {
                                    self.appdel?.extras.cities = cities
                                    self.homeCityTable?.reloadData()
                                    self.homeCityTable?.hidden = false
                                    self.txtHomeCity.enabled = true
                                    self.txtHomeCity.becomeFirstResponder()
                                    
                                    
                                }
                                
                            })
                        }catch
                        {
                            
                        }
                        
                    }else
                    {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            print("not found")
                            if tag == 1
                            {
                                self.tableview?.hidden = true
                                self.txtCurCity.enabled = true
                                self.txtCurCity.becomeFirstResponder()
                                
                                
                            }else if tag == 2
                            {
                                
                                self.homeCityTable?.hidden = true
                                self.txtHomeCity.enabled = true
                                self.txtHomeCity.becomeFirstResponder()
                                
                                
                            }

                        })
                    }
                    
                }else
                {
                    if tag == 1
                    {
                        self.txtCurCity.enabled = true
                        self.txtCurCity.becomeFirstResponder()
                        
                        
                    }else if tag == 2
                    {
                        
                        self.txtHomeCity.enabled = true
                        self.txtHomeCity.becomeFirstResponder()
        
                        
                    }
                    
                    print(error)
                }
            }
            task.resume()
            
        }
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let appdel = UIApplication.sharedApplication().delegate as? AppDelegate
        cell.textLabel?.text = appdel?.extras.cities[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let appdel = UIApplication.sharedApplication().delegate as? AppDelegate
        
        return (appdel?.extras.cities.count)!
    }
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let appdel = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if tableView == tableview {
            txtCurCity.text = appdel?.extras.cities[indexPath.row]
            appdel?.profile.curCity = txtCurCity.text!
            tableview?.hidden = true
        }else if tableView == homeCityTable
        {
            txtHomeCity.text = appdel?.extras.cities[indexPath.row]
            appdel?.profile.homeCity = txtHomeCity.text!
            homeCityTable?.hidden = true
        }
        
    }

    
}
