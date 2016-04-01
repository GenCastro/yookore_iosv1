//
//  OnboardingLocationCellTableViewCell.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/09.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class OnboardingCell: UITableViewCell,UITableViewDelegate{

    @IBOutlet var lblCurCountry: UILabel?
    @IBOutlet var lblHomeCountry: UILabel!
    @IBOutlet var lblHomeCity: UILabel!
    
    @IBOutlet var lblSkulType: UILabel!
    @IBOutlet var lblYearTo: UILabel!
    @IBOutlet var lblYearFrom: UILabel!
    @IBOutlet var txtSkulName: UITextField!
    @IBOutlet var vwCurCountry: UIView!
    @IBOutlet var vwHomeCountry: UIView!
    @IBOutlet var vwHomeCity: UIView!

    @IBOutlet var vwSkulType: UIView!
    @IBOutlet var vwFrmYr: UIView!
    @IBOutlet var vwToYr: UIView!
        
    @IBOutlet var tableview: UITableView?
    
    @IBOutlet var txtCurCity: UITextField!
   

    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code

        
    }
    @IBAction func suggest(sender: AnyObject) {
       
        let tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
        tableView.delegate      =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(tableView)
        
        let appdel = UIApplication.sharedApplication().delegate as? AppDelegate
        
        var cities = [String]()
        let id = appdel?.profile.countryId
        let url = NSURL(string: "https://countryservice.yookos.com/api/v1/countryservice/countries/" + id! + "/cities/" + txtCurCity.text!)
        let request = HttpRequest().getRequest(url!, body: [:], method: "GET")
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
                        
                       
                        
                    }catch
                    {
                        
                    }
               
                }else
                {
                    print(response)
                }
                
            }else
            {
                print(error)
            }
        }
        task.resume()
        
        
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        return cell
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
