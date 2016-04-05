//
//  HobbiesNInterests.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/31.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class Hobbies: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var txtAdd: UITextField!
    @IBOutlet var tableView: UITableView!
    var hobby: [String] = ["Viper", "X", "Games"]
    @IBOutlet var vwTable: UIView!
    @IBOutlet var vwHobbiesAdded: UIView!
    
    
    var yAxis : CGFloat = 0
    var xAxis : CGFloat = 0
    var ySpaceLeft :CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate      =   self
        self.tableView.dataSource    =   self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ySpaceLeft = self.vwHobbiesAdded.frame.width
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addType(sender: AnyObject) {
        
        vwTable.hidden = false
        
        hobby.append(txtAdd.text!)
        tableView.reloadData()
        
    }
    
    @IBAction func next(sender: AnyObject) {
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hobby.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.hobby[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        
        let lblHobby = UILabel()
        
        lblHobby.tag = indexPath.row
        let text = self.hobby[indexPath.row] + "  x"
        lblHobby.numberOfLines = 0
        lblHobby.text = text
        lblHobby.font = lblHobby.font.fontWithSize(12)
        lblHobby.frame.origin.x = xAxis
        lblHobby.sizeToFit()
        
        lblHobby.layer.backgroundColor = Color().tokenColor().CGColor
        lblHobby.layer.cornerRadius = 4
        
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
        
        vwTable.hidden = true
        self.hobby = ["Viper", "X", "Games"]
    }
    
    func tokenTap(sender: UITapGestureRecognizer!) {
        
        sender.view!.removeFromSuperview()
        
    }
    
    
}
