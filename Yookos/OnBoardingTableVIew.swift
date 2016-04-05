//
//  OnBoardingTableVIew.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/09.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation


class OnBoardingTableVIew: UITableViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    @IBOutlet var tableview: UITableView!
    var cellComponants = OnboardingCell()
    
    var countries  = NSMutableArray()
    var countriesList = [String]()
    var country = NSMutableDictionary()
    var activity_view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    var txtSelectCountry :UITextField = UITextField()
    var pickerView:UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.navigationBar.barTintColor = Color().titleBarColor()
        self.view.backgroundColor = Color().titleBarColor()
        activity_view.frame =  CGRectMake(0.0, 0.0, 40.0,40.0)
        activity_view.center = self.view.center
        self.view.addSubview(activity_view)
        activity_view.bringSubviewToFront(self.view)
        
        //self.tableview.userInteractionEnabled = false
        self.tableview.backgroundColor = UIColor.clearColor()
        
        
        let body: NSDictionary? = NSDictionary()
        let url = Services().countriesUrl()
        let request = HttpRequest().getRequest(url, body: body!, method: "GET")
        
        dispatch_async( dispatch_get_main_queue(),{
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    let code = httpResponse.statusCode
                    print(code)
                    
                    if code == 200
                    {
                        do{
                            self.countries = try NSJSONSerialization.JSONObjectWithData((data! as NSData!), options: []) as! NSMutableArray
                            
                            
                            self.activity_view.stopAnimating()
                            self.tableview.userInteractionEnabled = true
                            self.tableview.backgroundColor = UIColor.whiteColor()
                            
                            
                            let curCountry =  NSUserDefaults.standardUserDefaults().valueForKey("country") as? String
                            
                            
                                var cntry = NSMutableDictionary()
                                for i in 0 ..< self.countries.count 
                                {
                                    cntry = self.countries[i] as! NSMutableDictionary
                                    
                                    let name = cntry.valueForKey("name") as! String
                                    self.countriesList.append(name)
                                    
                                    if(curCountry != nil && curCountry == name)
                                    {
                                        self.country = cntry
                                        let appDel = UIApplication.sharedApplication().delegate as? AppDelegate
                                        let id = cntry.valueForKey("id") as! NSNumber
                                        appDel?.profile.countryId = String(id)
                                    }
                                }
                            
                        }catch{
                            
                        }
                        
                    }else
                    {
                        
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
            
            task.resume();
        })
        // ADD A TOOLBAR WITH A DONE BUTTON
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.barTintColor = Color.init().pickerBarColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(OnBoardingTableVIew.donePicking(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton,spaceButton,doneButton], animated: true)
        toolBar.userInteractionEnabled = true
        
        //CREATE A PICKER AND ASSIGN IT AS INPUT OF A TEXTFIELD
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.sizeToFit()
        
        
        txtSelectCountry.inputView = pickerView
        txtSelectCountry.inputAccessoryView = toolBar
        txtSelectCountry.text = "all"
        
        self.view.addSubview(txtSelectCountry)
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        var cell = OnboardingCell()
        
        
        if indexPath.section == 0
        {
            tableView.registerNib(UINib(nibName: "Location", bundle: nil), forCellReuseIdentifier: "locationCell")
            
            cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! OnboardingCell
            
            
            //DEALING WITH THE CURRENT COUNTRY
            var tap = UITapGestureRecognizer(target: self, action: #selector(OnBoardingTableVIew.countryTap(_:)))
            cell.vwCurCountry.addGestureRecognizer(tap)
            cell.vwCurCountry.tag = 1
            cell.vwCurCountry.layer.borderWidth = 1
            cell.vwCurCountry.layer.borderColor = Color().viewBorderColor()
            
            
            //DEALING WITH THE CURRENT COUNTRY
            tap = UITapGestureRecognizer(target: self, action: #selector(OnBoardingTableVIew.countryTap(_:)))
            cell.vwHomeCountry.addGestureRecognizer(tap)
            cell.vwHomeCountry.tag = 2
            cell.vwHomeCountry.layer.borderWidth = 1
            cell.vwHomeCountry.layer.borderColor = Color().viewBorderColor()
            
            //DEALING WITH THE CURRENT COUNTRY
            tap = UITapGestureRecognizer(target: self, action: #selector(OnBoardingTableVIew.city(_:)))
            cell.vwHomeCity.addGestureRecognizer(tap)
            cell.vwHomeCity.layer.borderWidth = 1
            cell.vwHomeCity.layer.borderColor = Color().viewBorderColor()
            
            let curCountry =  NSUserDefaults.standardUserDefaults().valueForKey("country") as? String
            
            if(curCountry != nil)
            {
                
                cell.lblCurCountry!.text = curCountry
                cell.lblCurCountry?.textColor = UIColor.blackColor()
            }
            
        }else if indexPath.section == 1
        {
            tableView.registerNib(UINib(nibName: "School", bundle: nil), forCellReuseIdentifier: "schoolCell")
            
            cell = tableView.dequeueReusableCellWithIdentifier("schoolCell", forIndexPath: indexPath) as! OnboardingCell
            
            //DEALING WITH THE CURRENT COUNTRY
            var tap = UITapGestureRecognizer(target: self, action: #selector(OnBoardingTableVIew.skulTypeTap(_:)))
            cell.vwSkulType.addGestureRecognizer(tap)
            cell.vwSkulType.layer.borderWidth = 1
            cell.vwSkulType.layer.borderColor = Color().viewBorderColor()
            
            //DEALING WITH THE CURRENT COUNTRY
            tap = UITapGestureRecognizer(target: self, action: Selector("yearFrom:"))
            cell.vwFrmYr.addGestureRecognizer(tap)
            cell.vwFrmYr.layer.borderWidth = 1
            cell.vwFrmYr.layer.borderColor = Color().viewBorderColor()
            
            //DEALING WITH THE CURRENT COUNTRY
            tap = UITapGestureRecognizer(target: self, action: Selector("yearTo:"))
            cell.vwToYr.addGestureRecognizer(tap)
            cell.vwToYr.layer.borderWidth = 1
            cell.vwToYr.layer.borderColor = Color().viewBorderColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 340
        }
        
        if indexPath.section == 1
        {
            return 238
        }
        
        return 0
    }
    
    /*############################################################################################
    
    ------>  ---->  WHEN VIEWS ARE TAPPED
    
    ###########################################################################################*/
    
    func countryTap(sender:UITapGestureRecognizer) {
        
        print("called")
        
        
        let curCountry = NSUserDefaults.standardUserDefaults().objectForKey("country") as? String
        
        if(curCountry != nil)
        {
            pickerView.selectRow(countriesList.indexOf(curCountry!)!, inComponent: 0, animated: true)
            
        }
        
        txtSelectCountry.becomeFirstResponder()
       
    }
    func stateTap(sender:UITapGestureRecognizer){
        
        let links = country.valueForKey("_links") as? NSDictionary
        let regions = links?.valueForKey("regions")
        let href = regions?.valueForKey("href") as? String
        
        print(href)
        let url = NSURL(string: href!)
        let request = HttpRequest().getRequest(url!, body: [:], method: "GET")
        defer{
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){data,response,error in
            
            
            if let httpResponse = response as? NSHTTPURLResponse
            {
                let code = httpResponse.statusCode
                print(code)
                if code == 200
                {
                    do
                    {
                        let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        
                        print(jsonData)
                        print(response)
                    }catch
                    {
                        
                    }
                }else
                {
                    print(response)
                }
            }else
            {
                let alert = UIAlertController(title: "ERROR", message: String(error), preferredStyle: .Alert)
                
                UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
            }
            
            if error != nil
            {
                print(error)
            }
        }
            task.resume()
        }
        print(country)
        
    }
    func city(sender:UITapGestureRecognizer){
        
        print(country)
        
    }
    func skulTypeTap(sender:UITapGestureRecognizer){
        
        print(country)
        
    }
    func yearFromTap(sender:UITapGestureRecognizer){
        
        print(country)
        
    }
    func YearToTap(sender:UITapGestureRecognizer){
        
        print(country)
        
    }
    
        /*############################################################################################
    
    ------>  ---->  WHEN PICKER APPEARS/DISAPPEARS
    
    ###########################################################################################*/
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return countriesList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return countriesList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        print(countriesList[row])
        
        tableView.registerNib(UINib(nibName: "School", bundle: nil), forCellReuseIdentifier: "schoolCell")
        
        cellComponants = tableView.dequeueReusableCellWithIdentifier("schoolCell") as! OnboardingCell
        
        NSUserDefaults.standardUserDefaults().setValue(countriesList[row], forKey: "country")
        country = countries[row] as! NSMutableDictionary
        tableview.reloadData()
        
        print(country)
        
    }
    func donePicking(sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
    }

  
}