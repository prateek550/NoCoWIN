//
//  AppDelegate.swift
//  OMDB Client
//
//  Created by Prateek Pande on 28/09/18.
//  Copyright © 2018 Prateek Pande. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if UserDefaultService.hasKey(for: UserDefaultService.TOKEN_KEY){
            UIApplication.shared.setMinimumBackgroundFetchInterval(1800)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        UserDefaultService.incrementPreferenceCounter(for: UserDefaultService.APP_REFRESH_COUNTER)
                
        AppointmentService.getCenters { _, slots in
            
            if let haveSlots = slots{
                
                UserDefaultService.incrementPreferenceCounter(for: UserDefaultService.SUCCESS_API_COUNTER)
                
                let centers = AppointmentProcessor.processSlots(slots: haveSlots, filter: UserDefaultService.getPreferences(for: UserDefaultService.FILTER_KEY) as? AppointmnetFilter)
                
                if centers.isEmpty{
                    self.notifyUser(title: "Having a bad day !", body: "Will retry in sometime")
                    completionHandler(.noData)
                }
                else{
                    UserDefaultService.incrementPreferenceCounter(for: UserDefaultService.CENTERS_FOUND_COUNTER)
                    self.notifyUser(title: "You got lucky !", body: (String(centers.count)+" centers are waiting for you !!"))
                    completionHandler(.newData)
                }
            }
            else{
                completionHandler(.failed)
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
        if UserDefaultService.hasKey(for: UserDefaultService.TOKEN_KEY){
            UIApplication.shared.setMinimumBackgroundFetchInterval(1800)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        if let navVC = application.keyWindow?.rootViewController as? UINavigationController, let vc = navVC.topViewController as? ViewController{
            vc.reloadCounters()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    private func notifyUser(title: String, body: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 1.0)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
          )
        
        UNUserNotificationCenter.current().add(request)
    }

}

