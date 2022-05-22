//
//  AppDelegate.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2020/12/29.
//


import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var isCherishPeopleCellSelected:Bool = false
    var isCherishPostponed:Bool = false
    var isCherishDeleted:Bool = false
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 1.0) // Launch Screen 1초간 유지
        
        UNUserNotificationCenter.current().delegate = self
        
        // MARK: Firebase 초기화
        FirebaseApp.configure()
        
        /// 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        /// 자동 초기화 방지
        Messaging.messaging().isAutoInitEnabled = true
        
        
        /// 현재 등록 토큰 가져오기
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        /// 푸시 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                if granted {
                    /// APN에 토큰 매핑하는 프로세스
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        )
        
        return true
    }
    
    // [START receive_message]
    // 앱이 꺼져있을 때도 pushAlarm 받는 함수
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        let pushTypeInUserInfo = (userInfo[AnyHashable("pushType")]! as! NSString).intValue
        
        if pushTypeInUserInfo == 1 {
            let cherishIdinUserInfo = userInfo[AnyHashable("CherishId")]!
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "CherishTabBarController")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            NotificationCenter.default.post(name: .pushSelected, object: cherishIdinUserInfo)
        } else {
            print("물주기 기록 푸시")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        let pushTypeInUserInfo = (userInfo[AnyHashable("pushType")]! as! NSString).intValue
        
        // 물 줄 시간이에요 푸시
        if pushTypeInUserInfo == 1 {
            let cherishIdinUserInfo = userInfo[AnyHashable("CherishId")]!
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "CherishTabBarController")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            NotificationCenter.default.post(name: .pushSelected, object: cherishIdinUserInfo)
        } else {
            print("물주기 기록 푸시")
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    // 앱이 foreground상태일 때, 알림이 온 경우 어떻게 표시할 것인지 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler([[.alert, .sound]])
    }
    
    // push가 온 경우 처리
    // 앱을 실행한 적이 있을 때 처리되는 곳(foreground)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Print message ID.
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if response.actionIdentifier == UNNotificationDismissActionIdentifier {
            print ("Message Closed")
        } else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            let pushTypeInUserInfo = (userInfo[AnyHashable("pushType")]! as! NSString).intValue
            
            // 물 줄 시간이에요 푸시
            if pushTypeInUserInfo == 1 {
                let cherishIdinUserInfo = userInfo[AnyHashable("CherishId")]!
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CherishTabBarController")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                NotificationCenter.default.post(name: .pushSelected, object: cherishIdinUserInfo)
            } else {
                print("물주기 기록 푸시")
            }
        }
        completionHandler()
    }
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
    }
}
