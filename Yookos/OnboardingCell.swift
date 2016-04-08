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
    
    var selectedRow = false

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
    @IBAction func suggest(sender: UITextField) {
       
        self.tableview?.hidden = true
        self.homeCityTable.hidden = true
        let tag = sender.tag
        
        if tag == 1 {
            if txtCurCity.text != ""{
                
                self.txtCurCity.enabled = false
                getCities(tag, text: txtCurCity.text!)
            }
        }else if tag == 2
        {
            if txtHomeCity.text != ""{
                
                self.txtHomeCity.enabled = false
                getCities(tag, text: txtHomeCity.text!)
            }
        }
        
        
        
    }
    
    func getCities(tag:Int,text:String)
    {
        let appdel = UIApplication.sharedApplication().delegate as? AppDelegate
        
        var cities = [String]()
        let id = appdel?.profile.countryId
        let url =
            Services().getCities(id!, name: text)
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
                                    appdel?.extras.cities = cities
                                    self.tableview?.reloadData()
                                    self.tableview?.hidden = false
                                    self.txtCurCity.enabled = true
                                    self.txtCurCity.becomeFirstResponder()
                                    
                                    
                                    
                                }else if tag == 2
                                {
                                    appdel?.extras.cities = cities
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
                        print("not found")
                        if tag == 1
                        {
                            appdel?.extras.cities = cities
                            self.tableview?.reloadData()
                            self.tableview?.hidden = false
                            self.txtCurCity.enabled = true
                            self.txtCurCity.becomeFirstResponder()
                            
                            
                        }else if tag == 2
                        {
                            appdel?.extras.cities = cities
                            self.homeCityTable?.reloadData()
                            self.homeCityTable?.hidden = false
                            self.txtHomeCity.enabled = true
                            self.txtHomeCity.becomeFirstResponder()
                            
                            
                        }
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
        selectedRow = true
        txtCurCity.text = appdel?.extras.cities[indexPath.row]
        tableview?.hidden = true
    }

    
}
