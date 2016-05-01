//
//  AppDelegate.swift
//  Pirinola24
//
//  Created by Aplimovil on 27/04/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    let APP_ID = "B53B1BEE-A372-0051-FF78-52D40FC4F000"
    let SECRET_KEY = "DD1561C9-F5FE-BCB6-FF6C-7A73A70D4D00"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    
    var window: UIWindow?   


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        let pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor.whiteColor()
        pageController.currentPageIndicatorTintColor = UIColor.blackColor()
        
        let colorBackground = UIColor(red: 234/255, green: 28/255, blue: 36/255 , alpha: 1)
        pageController.backgroundColor = colorBackground
        
                
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

