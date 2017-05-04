//
//  AppDelegate.swift
//  OstomyScan
//
//  Created by Lucas Cauthen on 1/15/17.
//  Copyright © 2017 OstomyTech. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var STdebugger: Bool = true
    func preventApplicationFromStartingInTheBackgroundWhenTheStructureSensorIsPlugged() {
        if UIApplication.shared.applicationState == .background {
            let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName")
            print("iOS launched \(displayName) in the background. This app is not designed to be launched in the background, so it will exit peacefully.")
            
            exit(0)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        preventApplicationFromStartingInTheBackgroundWhenTheStructureSensorIsPlugged()
        if (STdebugger)
        {
            // STWirelessLog is very helpful for debugging while your Structure Sensor is plugged in.
            // See SDK documentation for how to start a listener on your computer.
            
            var error: NSError? = nil
            let remoteLogHost = "10.157.238.39"
            
            STWirelessLog.broadcastLogsToWirelessConsole(atAddress: remoteLogHost, usingPort: 49999, error: &error)
            
            if error != nil {
                let errmsg = error!.localizedDescription
                NSLog("Oh no! Can't start wireless log: %@", errmsg)
            }
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

