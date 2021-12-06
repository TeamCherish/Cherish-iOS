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
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        var initialViewController: UIViewController?
        window = UIWindow(windowScene: windowScene)
        
        // 자동 로그인이 될 때 첫 Scnene을 메인뷰로
        if let _ = UserDefaults.standard.string(forKey: "loginEmail") {
            // 등록된 식물이 하나 이상 존재한다면 메인뷰로 이동
            if UserDefaults.standard.bool(forKey: "isPlantExist") == true {
                print("첫 로드 : 메인뷰")
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                initialViewController = storyboard.instantiateViewController(withIdentifier: "CherishTabBarController")
            } else {
                print("첫 로드 : 등록된 식물이 없어요 뷰")
                let storyBoard = UIStoryboard(name: "AddUser", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "AddUserVC")
                initialViewController = UINavigationController(rootViewController: vc)
            }
        } else {
            if UserDefaults.standard.bool(forKey: "OnboardingHaveSeen") == true {
                // 자동 로그인이 아닐 때는 첫 Scnene을 로그인뷰로
                print("첫 로드 : 로그인뷰")
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                initialViewController = UINavigationController(rootViewController: vc)
            } else {
                print("첫 로드 : 온보딩뷰")
                let storyBoard = UIStoryboard(name: "Onboarding", bundle: nil)
                let vc = storyBoard.instantiateViewController(identifier: "OnboardingVC")
                initialViewController = UINavigationController(rootViewController: vc)
            }
        }
        
        guard let initialViewController = initialViewController else { return }
        self.window?.rootViewController = initialViewController
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
        guard let _ = UserDefaults.standard.value(forKey: "AppLockPW") else { return }
        self.setBlurryView(false)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        guard let _ = UserDefaults.standard.value(forKey: "AppLockPW") else { return }
        self.setBlurryView(true)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        if let _ = UserDefaults.standard.value(forKey: "AppLockPW") {
            let lock = SetLockVC().then { $0.modeSelect = .unlock }
            window?.rootViewController?.view.window?.addSubview(lock.view)
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        guard let _ = UserDefaults.standard.value(forKey: "AppLockPW") else { return }
        self.setBlurryView(true)
    }
    
    
    private func setBlurryView(_ needToShow: Bool) {
        let viewTag = -703
        let blurryView = window?.rootViewController?.view.window?.viewWithTag(viewTag)
        if needToShow {
            if blurryView == nil {
                window?.rootViewController?.view.window?.addSubview(BlurryView(viewTag: viewTag))
            }
        } else {
            guard let blurryView = blurryView else { return }
            blurryView.removeFromSuperview()
        }
    }
}

