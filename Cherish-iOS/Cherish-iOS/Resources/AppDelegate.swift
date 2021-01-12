//
//  AppDelegate.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2020/12/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    var isCherishPeopleCellSelected:Bool = false
    var pushArray:[String] = []
    var pushSendArray:[String] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // APNS 설정
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) {
            [weak self] granted, error in
            
            print("Permission granted: \(granted)")
        }
        //APNS 등록
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Push Notification received: \(userInfo)")
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
    
    //실패시
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
    
    //성공시
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data)}
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 앱은 꺼져있지만 완전히 종료되지 않고 백그라운드에서 실행중일 때
    // 푸시 메시지 클릭 시 클릭 이벤트가 전달되는 함수
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // push 에서 전달받은 UserInfo 데이터를 변수에 담는다
        let userInfo = response.notification.request.content.userInfo
        
        //aps 메시지 print
        print("Push Notification received: \(userInfo)")
        
        
        // UserDefaults에 URL 정보 저장
        // PUSH_URL 이름의 키로 userInfo 안 데이터를 저장
        let userDefault = UserDefaults.standard
        userDefault.set("하이하이", forKey: "PUSH_URL")
        //푸시를 클릭했을 때 array가 append됨
        pushArray.append(userDefault.string(forKey: "PUSH_URL")!)
        userDefault.synchronize()
        print(pushArray)
        completionHandler()
    }
    
    // 앱이 켜져 있는 상태에서 푸시를 받았을 때 호출되는 함수
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//
//
//        completionHandler()
//    }
}
