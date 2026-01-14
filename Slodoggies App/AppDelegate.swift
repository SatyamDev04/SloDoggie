//
//  AppDelegate.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 12/11/25.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import GoogleMaps
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        FirebaseConfiguration.shared.setLoggerLevel(.debug)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermission()
        GMSPlacesClient.provideAPIKey("AIzaSyCinDdjJJjl5Fl1LqrNUOjBQAW3_Uzy4YU")
        GMSServices.provideAPIKey("AIzaSyCinDdjJJjl5Fl1LqrNUOjBQAW3_Uzy4YU")
        return true
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("❌ Notification permission error:", error.localizedDescription)
            } else {
                print("✅ Notification permission granted:", granted)
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
    }
   

    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("APNs token set:", deviceToken)
        
        // Now that we have APNs token, get FCM token
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token:", error)
            } else if let token = token {
                print("FCM token:", token)
                UserDetail.shared.setFcmToken(token)
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token:", fcmToken ?? "nil")
        UserDetail.shared.setFcmToken(fcmToken ?? "")
    }
}
