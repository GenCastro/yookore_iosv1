//
//  ViewController.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/02/25.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate{

    var appDel:AppDelegate?
    //let locationManager = CLLocationManager()
    @IBOutlet var welcomeView: UIView!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnSingUp: UIButton!
    @IBOutlet var imgLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        

        //adding the background picture
        UIGraphicsBeginImageContext(welcomeView.frame.size);
        
        UIGraphicsBeginImageContext(welcomeView.frame.size)
        UIImage(named: "background.png")?.drawInRect(welcomeView.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        welcomeView.backgroundColor = UIColor(patternImage: image)
        
        imgLogo.layer.cornerRadius = 2.0;
        imgLogo.clipsToBounds = true;
        
        btnLogin.layer.cornerRadius = 2
        btnSingUp.layer.cornerRadius = 2
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToLogin() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("login") as! LoginViewController
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }

    @IBAction func goToSignUp() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("signup") as! SignUpViewController
        self.presentViewController(nextViewController, animated:true, completion:nil)
        
    }
}

