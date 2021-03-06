//
//  AppDelegate.swift
//  MyTime
//
//  Created by Brian Corrieri on 04/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import UIKit
import CloudKit
import IceCream
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var syncEngine: SyncEngine?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
        
        let appGroupUrl = FileManager
        .default
        .containerURL(forSecurityApplicationGroupIdentifier: "group.FairTrip.MyTime")!
        .appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: appGroupUrl,
        objectTypes: [TimerRealm.self, TimerIntervalRealm.self])
        
        Realm.Configuration.defaultConfiguration = config
        
        syncEngine = SyncEngine(objects: [
                SyncObject<TimerRealm>(),
                SyncObject<TimerIntervalRealm>()
            ], databaseScope: .private)
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let dict = userInfo as? [String: NSObject], let notification = CKNotification(fromRemoteNotificationDictionary: dict), let subscriptionID = notification.subscriptionID, IceCreamSubscription.allIDs.contains(subscriptionID) {
            NotificationCenter.default.post(name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil, userInfo: userInfo)
            completionHandler(.newData)
        }
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        syncEngine?.pull()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

