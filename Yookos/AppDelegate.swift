//
//  AppDelegate.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/02/25.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var services :Services!
    var profile :Profile!
    var httpRequest :HttpRequest!
   
    var extras : Extras!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        

        services = Services.init()
        profile = Profile.init()
        httpRequest = HttpRequest.init()
        extras = Extras.init()
        
//        let plist = NSBundle.mainBundle().pathForResource("UserInfo", ofType: "plist")
//        let dict = NSMutableDictionary(contentsOfFile: plist!)
//        let proStat = dict?.objectForKey("userStage") as! String
//        
//        if proStat.characters.count != 0
//        {
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let initView = storyBoard.instantiateViewControllerWithIdentifier(proStat)
//            
//            self.window?.rootViewController = initView
//        }
       
        self.window?.makeKeyAndVisible()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            
            
            
        
             FBSDKApplicationDelegate.sharedInstance().application(
                application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
            return true
            
            
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
       
        window?.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        let urlParams = url.path
        
        if urlParams == ""
        {
            print("nothing")
        }else
        {
            print(urlParams)
        }
        
        return true
    }
    
   /* func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }*/

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        let urlParams = url.path
        url.host
        print(url.host)
        print(urlParams)
        if urlParams == nil
        {
            print("nothing")
        }else
        {
            if url.host == "user"
            {
                let splitParms = urlParams?.componentsSeparatedByString("/")
                
                let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
                
                
                
                appDel.profile.access_token = splitParms![1]
                appDel.profile.userid = splitParms![0]
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("welcome2")
                UIViewController.topMostController().presentViewController(nextViewController, animated:true, completion:nil)
                
                let myEmail = NSUserDefaults.standardUserDefaults().objectForKey("email")
                if ( myEmail != nil) {
                 
                  
                        
                    
                    let json : [String : AnyObject] = ["email" : myEmail!,"token": appDel.profile.access_token!,"userid" : appDel.profile.userid!,"isnewuser" : true ]
                        
                    let request = appDel.httpRequest.getRequest(appDel.services.verifyUser(), body: json,method: "POST")
                    
                    defer{
                        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                            
                            if let httpResponse = response as? NSHTTPURLResponse {
                                
                                let code = httpResponse.statusCode
                                print(code)
                                
                                if code == 200
                                {
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("welcome2")
                                    UIViewController.topMostController().presentViewController(nextViewController, animated:true, completion:nil)
                                }else
                                {
                                    
                                }
                                
                                print(" passed 1" )
                                
                            }else
                            {
                                
                            }
                            
                            if error != nil{
                                
                                print(error)
                                return
                            }
                            
                        }
                        
                        task.resume()
                        
                        print("task done")}
                    
                }
                
                
                
            }else if url.host == "reset"
            {// Show login
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("setpwd")
                UIViewController.topMostController().presentViewController(nextViewController, animated:true, completion:nil)
                
            }else if url.host == "authorize"
            {
                
            }
        }
        
        
        return true
    }
    

}

