//
//  Onboarding2ViewController.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/04/03.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class Onboarding2ViewController: UIViewController {

    
    

    @IBOutlet var vwContainer: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchCity(sender: UITextField) {
        
        if sender.text == ""
        {
            vwContainer.hidden = true
        }else
        {
            vwContainer.hidden = false
            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            appDel.extras?.cities = sender.text?.characters.count
            
            dispatch_async(dispatch_get_main_queue(), {
                SuggestedCities().updateCities()
            })
            
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
