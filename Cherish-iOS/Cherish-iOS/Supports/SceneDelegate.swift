//
//  SceneDelegate.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2020/12/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let userID = UserDefaults.standard.integer(forKey: "userID")
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // 자동 로그인이 될 때 첫 Scnene을 메인뷰로
        if (UserDefaults.standard.string(forKey: "loginEmail") != nil) == true {
            appDel.isLoginManually = false
            // 등록된 식물 0일 때, noplnatView로 띄우기!!
            // 유저 idx 기반으로 메인뷰에 등록된 소중한 사람이 있는지 조회
            MainService.shared.inquireMainView(idx: userID){ [self]
                (networkResult) -> (Void) in
                switch networkResult {
                case .success(let data):
                    if let mainData = data as? MainData {
                        print(userID)
                        
                        // 등록된 소중한 사람의 수가 존재한다면
                        if mainData.totalCherish > 0 {
                            
                            // 메인뷰로 이동
                            print("첫 로드 : 메인뷰")
                            UserDefaults.standard.set(true,forKey: "autoLogin")
                            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                            let initialViewController = storyboard.instantiateViewController(withIdentifier: "CherishTabBarController")
                            self.window?.rootViewController = initialViewController
                            self.window?.makeKeyAndVisible()
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                        
                        // 소중한 사람이 한명도 등록되지 않았다면
                        else {
                            print("첫 로드 : 등록된 식물이 없어요 뷰")
                            UserDefaults.standard.set(true,forKey: "autoLogin")
                            let storyBoard: UIStoryboard = UIStoryboard(name: "AddUser", bundle: nil)
                            let initialViewController = storyBoard.instantiateViewController(withIdentifier: "AddUserNC")
                            self.window?.rootViewController = initialViewController
                            self.window?.makeKeyAndVisible()
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                case .requestErr(let msg):
                    if let message = msg as? String {
                        print(message)
                    }
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            }
        }
        // 자동 로그인이 아닐 때는 첫 Scnene을 로그인뷰로
        else {
            print("첫 로드 : 로그인뷰")
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginNC")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

