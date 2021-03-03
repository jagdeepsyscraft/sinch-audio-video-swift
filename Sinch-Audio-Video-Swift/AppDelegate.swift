//
//  AppDelegate.swift
//  Sinch-Audio-Video-Swift
//
//  Created by Jagdeep Mishra on 03/03/21.
//  Copyright © 2021 Syscraft Information System. All rights reserved.
//

import UIKit
import Sinch

@main
class AppDelegate: UIResponder, UIApplicationDelegate, SINClientDelegate {

    var client: SINClient!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        func onUserDidLogin(_ userId: String)
        {
           // self.push?.registerUserNotificationSettings()
            print("calling initSinch")
            self.initSinchClient(withUserId: userId)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("UserDidLoginNotification"), object: nil, queue: nil, using: {(_ note: Notification) -> Void in
            print("Got notification")
            let userId = note.userInfo!["userId"] as? String
            UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults.standard.synchronize()
            onUserDidLogin(userId!)
        })
        
        return true
    }

    func initSinchClient(withUserId userId: String) {
        
        if client == nil {
            print("initializing client 2")
            client = Sinch.client(withApplicationKey: "<Your_Client_Key>",
                                  applicationSecret: "<Your_Client_Secret>",
                                  environmentHost: "sandbox.sinch.com",
                                  userId: userId)
            client.delegate = self
            client.setSupportCalling(true)
            client.start()
            client.startListeningOnActiveConnection()

        }
    }
    
    //SINCallClient delegates
    func clientDidStart(_ client: SINClient!) {
        print("Sinch client started successfully (version: \(Sinch.version()) with userid \(client.userId)")
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        print("Sinch client error: \(String(describing: error?.localizedDescription))")
    }
    
    func client(_ client: SINClient, logMessage message: String, area: String, severity: SINLogSeverity, timestamp: Date) {
        
        print("\(message)")
        
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

