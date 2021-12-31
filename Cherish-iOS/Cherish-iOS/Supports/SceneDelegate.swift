//
//  SceneDelegate.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2020/12/29.
//

import UIKit
import Then

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let tagKeys = ["lock":-703, "blur":703]
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        var initialViewController: UIViewController?
        window = UIWindow(windowScene: windowScene)
        
        // 자동 로그인이 될 때 첫 Scnene을 메인뷰로
        if let _ = UserDefaults.standard.string(forKey: "loginEmail") {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            initialViewController = storyboard.instantiateViewController(withIdentifier: "CherishTabBarController")
        } else {
            if UserDefaults.standard.bool(forKey: "OnboardingHaveSeen") == true {
                // 자동 로그인이 아닐 때는 첫 Scnene을 로그인뷰로
                print("첫 로드 : 로그인뷰")
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                initialViewController = NavigationController(rootViewController: vc)
            } else {
                print("첫 로드 : 온보딩뷰")
                let storyBoard = UIStoryboard(name: "Onboarding", bundle: nil)
                let vc = storyBoard.instantiateViewController(identifier: "OnboardingVC")
                initialViewController = NavigationController(rootViewController: vc)
            }
        }
        
        guard let initialViewController = initialViewController else { return }
        self.window?.rootViewController = initialViewController
        self.window?.backgroundColor = .systemBackground
        self.window?.makeKeyAndVisible()
        UIApplication.shared.unregisterForRemoteNotifications()
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
        guard let _ = UserDefaults.standard.value(forKey: "AppLockPW"),
              let _ = UserDefaults.standard.string(forKey: "loginEmail") else { return }
        
        self.setBlurryView(false)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        guard let _ = UserDefaults.standard.value(forKey: "AppLockPW"),
              let _ = UserDefaults.standard.string(forKey: "loginEmail"),
              let key = tagKeys["lock"] else { return }
        
        guard let _ = window?.viewWithTag(key) else {
            self.setBlurryView(true)
            return
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        guard let _ = UserDefaults.standard.value(forKey: "AppLockPW"),
              let _ = UserDefaults.standard.string(forKey: "loginEmail"),
              let key = tagKeys["lock"]  else { return }
        
        self.setBlurryView(false)
        guard let _ = window?.viewWithTag(key) else {
            let lock = SetLockVC().then {
                $0.modeSelect = .unlock
                $0.view?.tag = key
            }
            window?.addSubview(lock.view)
            return
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        guard let _ = UserDefaults.standard.value(forKey: "AppLockPW"),
              let _ = UserDefaults.standard.string(forKey: "loginEmail"),
              let key = tagKeys["lock"] else { return }
        
        guard let _ = window?.viewWithTag(key) else {
            self.setBlurryView(true)
            return
        }
    }
    
    
    private func setBlurryView(_ needToShow: Bool) {
        guard let key = tagKeys["blur"] else { return }
        
        let blurryView = window?.viewWithTag(key)
        if needToShow {
            if blurryView == nil {
                window?.addSubview(BlurryView(viewTag: key))
            }
        } else {
            guard let blurryView = blurryView else { return }
            blurryView.removeFromSuperview()
        }
    }
}

