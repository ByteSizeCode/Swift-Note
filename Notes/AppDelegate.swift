//
//  AppDelegate.swift
//  notes
//
//  Created by Isaac Raval on 4/2/19.
//  Copyright © 2019 organization. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let splitViewController = window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        
        
        print("Reading from user defaults")
        //Read notes from UserDefaults
        let prefs = UserDefaults.standard //setup for UserDefaults
        
        //Add all saved notes from user defaults
        print(MasterViewController.vals.objects.count)
        let decoded  = prefs.data(forKey: "1")
        if(decoded != nil) {
            let decodedSavedNotes = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Note]
            MasterViewController.vals.objects = decodedSavedNotes
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("entering background")
        
        //Store array of notes to UserDefaults
        let prefs = UserDefaults.standard
        //        prefs.set(MasterViewController.vals.objects, forKey: "1")
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: MasterViewController.vals.objects)
        prefs.set(encodedData, forKey: "1")
        prefs.synchronize()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("entering foreground")
        //Read notes from UserDefaults
        let prefs = UserDefaults.standard //setup for UserDefaults
        
        //Clear array of notes and add all saved notes from user defaults
        print(MasterViewController.vals.objects.count)
        if(MasterViewController.vals.objects.count > 0) {
            MasterViewController.vals.objects.removeAll()
            let decoded  = prefs.data(forKey: "1")
            let decodedSavedNotes = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Note]
            MasterViewController.vals.objects = decodedSavedNotes
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.contentOfNote == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
}

