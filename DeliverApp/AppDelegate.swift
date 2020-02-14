//
//  AppDelegate.swift
//  DeliverApp
//
//  Created by User 2 on 4/24/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import IQKeyboardManagerSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
      
    Thread.sleep(forTimeInterval: 3)
    
        GMSPlacesClient.provideAPIKey("AIzaSyCgp-oF7rarrvQFI8Tm2rzVZ8IrrIdALeQ")
    
        GMSServices.provideAPIKey("AIzaSyCgp-oF7rarrvQFI8Tm2rzVZ8IrrIdALeQ")
        
          IQKeyboardManager.shared.enable = true
        
        if UserDefaults.standard.bool(forKey: "user_login_status") == true {

            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homePageView = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
             window?.rootViewController = homePageView
             window?.makeKeyAndVisible()
            
        }else{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let phoneviewController = mainStoryboard.instantiateViewController(withIdentifier: "PhoneNumberViewController") as UIViewController
            UIApplication.shared.keyWindow?.rootViewController = phoneviewController;

            // go to login or signup screen
        }
        
        registerNotification()
        
        return true
    }
    
func registerNotification()  {
           let notificationCenter = UNUserNotificationCenter.current()
           notificationCenter.delegate = self 
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
               notificationCenter.requestAuthorization(options: options) {
                   (didAllow, error) in
                   if !didAllow {
                       print("User has declined notifications")
                   }
               }
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
        
        
        
        
        
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DeliverApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge,.alert,.sound])
   
    }
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
               return String(format: "%02.2hhx", data)
           }
           let token = tokenParts.joined()
           print(token)
   
    }
    
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
 //         let storyboard = UIStoryboard(name:"Main", bundle:nil)
//        if let OrderPlace = storyboard.instantiateViewController(withIdentifier:     "DeliveryOrderPlacedViewController") as! DeliveryOrderPlacedViewController
    
    
    //redirect to order details page
    
  }
    
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
    
        
    }
}


