//
//  OnBoardingTableVIew.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/09.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation


class OnBoardingTableVIew: UITableViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet var btnNext: UIBarButtonItem!
    
    @IBOutlet var tableview: UITableView!
    var cellComponants = OnboardingCell()
    
    var countries  = NSMutableArray()
    var countriesList = [String]()
    var citiesList = [String]()
    
    var country = NSMutableDictionary()
    var homeCountry = NSMutableDictionary()
    var activity_view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    var txtSelectCountry :UITextField = UITextField()
    var pickerView:UIPickerView!
    var pickerFor = ""
    var theCountry = ""
    var years = [String]()
    var yr = ""
    var skulType = ["University","College","High School"]
    var yrFrom = ""
    var yrTo = ""
    var skultype = ""
    
    var appDel = AppDelegate?()
    var year :Int?
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
        
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
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
            
            let curCountry =  NSUserDefaults.standardUserDefaults().valueForKey("country") as? String
            
            if(curCountry != nil)
            {
                
                cell.lblCurCountry!.text = curCountry
                cell.lblCurCountry?.textColor = UIColor.blackColor()
            }
            
            if appDel?.profile.homeCountry != "" {
                cell.lblHomeCountry.text = appDel?.profile.homeCountry
                cell.lblHomeCountry?.textColor = UIColor.blackColor()
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
            tap = UITapGestureRecognizer(target: self, action:  #selector(OnBoardingTableVIew.yearTap(_:)))
            cell.vwFrmYr.addGestureRecognizer(tap)
            cell.vwFrmYr.layer.borderWidth = 1
            cell.vwFrmYr.layer.borderColor = Color().viewBorderColor()
            
            //DEALING WITH THE CURRENT COUNTRY
            tap = UITapGestureRecognizer(target: self, action:  #selector(OnBoardingTableVIew.yearTap(_:)))
            cell.vwToYr.addGestureRecognizer(tap)
            cell.vwToYr.layer.borderWidth = 1
            cell.vwToYr.layer.borderColor = Color().viewBorderColor()
            
            
            if yrFrom != "" {
                cell.lblYearFrom.text = yrFrom
                cell.lblYearFrom?.textColor = UIColor.blackColor()
            }
            if yrTo != "" {
                cell.lblYearTo.text = yrTo
                cell.lblYearTo?.textColor = UIColor.blackColor()
            }
            if skultype != "" {
                cell.lblSkulType.text = skultype
                cell.lblSkulType?.textColor = UIColor.blackColor()
            }
            
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
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
        
        
        if countries.count < 1
        {
            return
        }
        
        pickerFor = "country"
        
        if sender.view?.tag == 1 {
            theCountry = "cur"
        }else{
            theCountry = "home"
        }
        
        let curCountry = NSUserDefaults.standardUserDefaults().objectForKey("country") as? String
        
        if(curCountry != nil)
        {
            pickerView.selectRow(countriesList.indexOf(curCountry!)!, inComponent: 0, animated: true)
            
        }
        
        txtSelectCountry.becomeFirstResponder()
       
    }
    /*func stateTap(sender:UITapGestureRecognizer){
        
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
        
    }*/
    
    func skulTypeTap(sender:UITapGestureRecognizer){
        
        pickerFor = "skul"
        
        txtSelectCountry.becomeFirstResponder()
        
    }
    func yearTap(sender:UITapGestureRecognizer){
        
        pickerFor = "year"
        
        if sender.view?.tag == 1
        {
            yr = "from"
            
        }else if sender.view!.tag == 2
        {
            yr = "to"
        }
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year], fromDate: date)
        
        year =  components.year
        
       
        
        for x in 0 ..< 100
        {
            years.append(String(year!-x))
        }
        
        txtSelectCountry.becomeFirstResponder()
        
    }
    
        /*############################################################################################
    
    ------>  ---->  WHEN PICKER APPEARS/DISAPPEARS
    
    ###########################################################################################*/
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerFor == "country" {
            
            return countriesList.count
            
        }else if pickerFor == "cities"
        {
            return citiesList.count
            
        }else if pickerFor == "year"
        {
            return years.count
            
        }else if pickerFor == "skul"
        {
            return skulType.count
        }else{
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        if pickerFor == "country" {
            
            return countriesList[row]
            
        }else if pickerFor == "cities"
        {
            return citiesList[row]
            
        }else if pickerFor == "year"
        {
            return years[row]
            
        }else if pickerFor == "skul"
        {
            return skulType[row]
        }else{
            return ""
        }
        
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        if pickerFor == "country"
        {
            if theCountry == "home"{
                
                appDel?.profile.homeCountry = countriesList[row]
                homeCountry = countries[row] as! NSMutableDictionary
                
                let id = homeCountry.valueForKey("id") as! NSNumber
                appDel?.profile.homeCountryId = String(id)
            }else
            {
                
                NSUserDefaults.standardUserDefaults().setValue(countriesList[row], forKey: "country")
                country = countries[row] as! NSMutableDictionary
                let id = country.valueForKey("id") as! NSNumber
                appDel?.profile.countryId = String(id)
            }
            
            
        }else if pickerFor == "year"
        {
            if yr == "to" {
                
                yrTo = years[row]
                
            }else if yr == "from"
            {
                yrFrom = years[row]
            }
           
        }else if pickerFor == "skul"
        {
            skultype = skulType[row]
        }
        
        tableview.reloadData()
        
    }
    func donePicking(sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
    }

    @IBAction func next(sender: AnyObject) {
        
        let curCountry =  NSUserDefaults.standardUserDefaults().valueForKey("country") as? String
        if curCountry == nil {
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let alert = UIAlertController(title: "Current Country", message: "we can not find your current country make sure you have internet access", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
            })
            return
        }
        if appDel?.profile.curCity == ""
        {
            dispatch_async(dispatch_get_main_queue(), {
                
                let alert = UIAlertController(title: "Current City", message: "please enter a valid city name(select one of the suggested cities as you type)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
            })
            return
        }
        
        if appDel?.profile.homeCountry == ""
        {
            dispatch_async(dispatch_get_main_queue(), {
                
                let alert = UIAlertController(title: "Home Country", message: "please select your home country", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
            })
            return
        }
        
        if appDel?.profile.homeCity == ""
        {
            dispatch_async(dispatch_get_main_queue(), {
                
                let alert = UIAlertController(title: "home City", message: "please enter a valid city name(select one of the suggested cities as you type)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
            })
            return
        }
        
        if appDel?.profile.schoolName == ""
        {
            dispatch_async(dispatch_get_main_queue(), {
                
                let alert = UIAlertController(title: "School Name", message: "please enter a school name", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
            })
            return
        }
        
        if skultype == ""
        {
            dispatch_async(dispatch_get_main_queue(), {
                
                let alert = UIAlertController(title: "School", message: "please select the type of school", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
            })
            return
        }
        
        if yrFrom == ""
        {
            dispatch_async(dispatch_get_main_queue(), {
                
                let alert = UIAlertController(title: "Time Period", message: "select the year you started school", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
            })
            return
        }
        
        if yrTo == ""
        {
            dispatch_async(dispatch_get_main_queue(), {
                
                let alert = UIAlertController(title: "Time Period", message: "select the year you finished school,select current year if you still at school", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
            })
            return
        }
        
        let x = Int(yrFrom)! - Int(yrTo)!
        
        if x > 0 {
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let alert = UIAlertController(title: "Time Period", message: "Your end date cannot be earlier than your start date", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
            })
            return
        }
        
        
        let url = Services().updateProfile((appDel?.profile.username)!)
        let body : [String : AnyObject] = ["userid" : (appDel?.profile.userid)!,
                    "currentcity": (appDel?.profile.curCity)!,
                    "currentcountry": curCountry!,
                    "homecountry": (appDel?.profile.homeCountry)!,
                    "hometown": (appDel?.profile.homeCity)!]
        
        let request = HttpRequest().getRequest(url, body: body, method: "PUT")
        
        defer{
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    let code = httpResponse.statusCode
                    print(code)
                    
                    if code == 200 || code == 201
                    {
                        print("yeah")
                        
                        let url = Services().addeducation((self.appDel?.profile.userid)!)
                        
                        var body : [String : AnyObject]?
                        
                        if self.year == Int(self.yrTo)
                        {
                            body = ["school": (self.appDel?.profile.schoolName)!,
                                    "type": self.skultype,
                                    "from_year": Int(self.yrFrom)!,
                                    "current" : true]
                        }else{
                            body = ["school": (self.appDel?.profile.schoolName)!,
                                    "type": self.skultype,
                                    "from_year": Int(self.yrFrom)!,
                                    "to_year": Int(self.yrTo)!,
                                    "current" : false]
                        }
                        
                        
                        let request = HttpRequest().getRequest(url, body: body!, method: "POST")
                        
                        defer{
                            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                                
                                if let httpResponse = response as? NSHTTPURLResponse {
                                    
                                    let code = httpResponse.statusCode
                                    print(code)
                                    
                                    if code == 200 || code == 201
                                    {
                                        
                                    }else if code ==  400
                                    {
                                        print("bad request")
                                    }else{
                                        
                                        dispatch_async( dispatch_get_main_queue(),{
                                            let alert = UIAlertController(title: "ERROR", message:"Oooops! something went wrong", preferredStyle: .Alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                                            UIViewController.topMostController().presentViewController(alert, animated: true){}
                                        })
                                    }
                                    
                                    
                                    
                                }else
                                {
                                    dispatch_async( dispatch_get_main_queue(),{
                                        let alert = UIAlertController(title: "ERROR", message:"Oooops! something went wrong", preferredStyle: .Alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                                        UIViewController.topMostController().presentViewController(alert, animated: true){}
                                    })
                                }
                                
                                if error != nil{
                                    
                                    dispatch_async( dispatch_get_main_queue(),{
                                        let alert = UIAlertController(title: "ERROR", message:"No Network Connection", preferredStyle: .Alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                                        UIViewController.topMostController().presentViewController(alert, animated: true){}
                                    })
                                    return
                                }
                                
                            }
                            
                            task.resume()
                        }
                    }else if code ==  400
                    {
                        print("bad request")
                    }else{
                        
                        dispatch_async( dispatch_get_main_queue(),{
                            let alert = UIAlertController(title: "ERROR", message:"Oooops! something went wrong", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                            UIViewController.topMostController().presentViewController(alert, animated: true){}
                        })
                    }
                    
                    
                }else
                {
                    dispatch_async( dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "ERROR", message:"Oooops! something went wrong", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                        UIViewController.topMostController().presentViewController(alert, animated: true){}
                    })
                }
                
                if error != nil{
                    
                    dispatch_async( dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "ERROR", message:"No Network Connection", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                        UIViewController.topMostController().presentViewController(alert, animated: true){}
                    })
                    return
                }
                
            }
            
            task.resume()
                
            
            print("task done")}
        
        
    }
  
}