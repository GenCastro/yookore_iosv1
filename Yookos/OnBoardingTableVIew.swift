//
//  OnBoardingTableVIew.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/09.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation


class OnBoardingTableVIew: UITableViewController,UITextFieldDelegate{
    
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        var cell = UITableViewCell()
        
        
        if indexPath.section == 0
        {
            tableView.registerNib(UINib(nibName: "Location", bundle: nil), forCellReuseIdentifier: "locationCell")
            
            cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! OnboardingCell
        }else if indexPath.section == 1
        {
            tableView.registerNib(UINib(nibName: "School", bundle: nil), forCellReuseIdentifier: "schoolCell")
            
            cell = tableView.dequeueReusableCellWithIdentifier("schoolCell", forIndexPath: indexPath) as! OnboardingCell
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 331
        }
        
        if indexPath.section == 1
        {
            return 238
        }
        
        return 0
    }
    
   
  
}