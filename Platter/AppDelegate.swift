//
//  AppDelegate.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 27/11/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //MARK: - Fire during first launch to set user as free user, allocate 0 tokens and take note of date
        
        let firstTime = FirstLaunch(userDefaults: .standard, key: Keys.firstAppDelegate)
        
        if firstTime.isFirstLaunch{
            
            UserDefaults.standard.set(1, forKey: Keys.tokenNumber)
 
            UserDefaults.standard.set(true, forKey: Keys.userStatus)
            
            let launchDate = Date()
            
            print (launchDate)
            
            UserDefaults.standard.set(launchDate, forKey: Keys.timeOfLaunch)
        }
        
        //MARK: - manually set user status *** remove ***
        
        //UserDefaults.standard.set(false, forKey: Keys.userStatus)
        //UserDefaults.standard.set(true, forKey: Keys.userStatus)
        
        
        //MARK: - Assign free user token after elapsed time
        
        let userStatus = UserStatus()
        
        if userStatus.isFreeUser(){
            
            let savedDate = UserDefaults.standard.object(forKey: Keys.timeOfLaunch) as! Date
            
            let timePassed = Float(Date().timeIntervalSince(savedDate))
            
            if timePassed >= 300{ //43200
                
                
                let currentDate = Date()
                
                print (currentDate)
                
                UserDefaults.standard.set(currentDate, forKey: Keys.timeOfLaunch)
                
                var tokens = UserDefaults.standard.float(forKey: Keys.tokenNumber)

                tokens += 1 //round(timePassed/300)
                
                print (tokens)

                UserDefaults.standard.set(tokens, forKey: Keys.tokenNumber)
                
                print ("got a token")
            }
            
            print (timePassed)
     
        }
 
        //print (Realm.Configuration.defaultConfiguration.fileURL)
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

