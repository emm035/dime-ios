//
//  AppDelegate.swift
//  Send Money
//
//  Created by Eric Marshall on 7/21/15.
//  Copyright (c) 2015 Eric Marshall. All rights reserved.
//

import UIKit
import RealmSwift
import Material
import MessageUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(
            // New schema version
            schemaVersion: 5,
            // Migration for Settings class
            migrationBlock: { migration, oldSchemaVersion in
                // Add "showTutorials" variable if it doesn't exist in the realm
                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: Settings.className()) { oldObject, newObject in
                        newObject!["showTutorial"] = true
                    }
                }
                
                // Add "showAds" variable if it doesn't exist in the realm
                if oldSchemaVersion < 2 {
                    migration.enumerateObjects(ofType: Settings.className()) { oldObject, newObject in
                        newObject!["showAds"] = true
                    }
                }
                
                if oldSchemaVersion < 3 {
                    migration.enumerateObjects(ofType: Expense.className()) { oldObject, newObject in
                        newObject!["imageIsDefault"] = true
                    }
                }

                if oldSchemaVersion < 4 {
                    migration.enumerateObjects(ofType: Expense.className(), { oldObject, newObject in
                        newObject!["category"] = ExpenseCategory.none.rawValue
                    })
                }

                if oldSchemaVersion < 5 {
                    // Removes the showAds property from the Settings object
                }
        })
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        
        // Set status bar to always be light
        UIApplication.shared.statusBarStyle = .lightContent

        // Set navigation bar colors
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = .greenTintColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        UITabBar.appearance().barTintColor = UIColor.barTintColor()
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: .selected)
        UITabBar.appearance().tintColor = UIColor.white
        
        UIToolbar.appearance().barTintColor = UIColor.barTintColor()
        UIToolbar.appearance().tintColor = UIColor.white
        
        // Create Settings object if id doesn't already exist
        if realm.objects(Settings.self).count == 0 {
            try! realm.write {
                realm.add(Settings(), update: false)
            }
        }
        
        // Create folder for app in documents directory
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let dataPath = documentsDirectory.appendingPathComponent("dime")
        if (!FileManager.default.fileExists(atPath: dataPath)) {
            try! FileManager.default .createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
        }
        
        // Only show tutorial on first view
        if !realm.objects(Settings.self)[0].showTutorial {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController =  storyboard.instantiateViewController(withIdentifier: "mainAppRootTabController") as! CustomTabViewController

        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension UIColor {
    
    public convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    class func barTintColor() -> UIColor {
        return UIColor(r: 33, g: 38, b: 43)
    }
    
    class func blueTintColor() -> UIColor {
        return UIColor(r: 14, g: 79, b: 131)
    }

    class func greenTintColor() -> UIColor {
        return UIColor(r: 42, g: 122, b: 44)
    }

    class func yellowTintColor() -> UIColor {
        return UIColor(r: 203, g: 155, b: 8)
    }

    class func redTintColor() -> UIColor {
        return UIColor(r: 173, g: 57, b: 31)
    }

    class func accentBlueColor() -> UIColor {
        return UIColor(r: 14, g: 129, b: 181)
    }

    class func accentGreenColor() -> UIColor {
        return UIColor(r: 78, g: 80, b: 1)
    }

    class func accentRedColor() -> UIColor {
        return UIColor(r: 144, g: 33, b: 30)
    }
}


extension Array {
    
    func insertionIndexOf(_ elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}

