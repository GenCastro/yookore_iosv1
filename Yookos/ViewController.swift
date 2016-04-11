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
    
    var latitude: String?
    var longitude: String?
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet var welcomeView: UIView!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnSingUp: UIButton!
    @IBOutlet var imgLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
        
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
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("signup")
        self.presentViewController(nextViewController, animated:true, completion:nil)
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[locations.count - 1]
        let defaults = NSUserDefaults.standardUserDefaults()
        let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(userLocation)
                    {
                        (placemarks, error) -> Void in
        
                        let placeArray = placemarks as [CLPlacemark]!
        
                        // Place details
                        var placeMark: CLPlacemark!
                        placeMark = placeArray?[0]
        
                        // Address dictionary
                        //print(placeMark.addressDictionary)
        
        
                        // City
                        if let city = placeMark.addressDictionary?["City"] as? NSString
                        {
                            print("City : \(city)")
                            defaults.setValue(city, forKey: "city")
                        }
                        
                        
                        // Country
                        if let country = placeMark.addressDictionary?["Country"] as? NSString
                        {
                           
                            defaults.setValue(country, forKey: "country")
                            defaults.setValue(placeMark.ISOcountryCode, forKey: "ISOCode")
                        }
                }
        locationManager.stopUpdatingLocation()
    }
    
}

