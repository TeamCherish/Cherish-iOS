//
//  CherishTabBarController.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit
import Then

class CherishTabBarController: UITabBarController {
    
    // 뷰 전체 폭 길이
    private let screenWidth = UIScreen.main.bounds.size.width
    
    // 뷰 전체 높이 길이
    private let screenHeight = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        if screenWidth >= 414 && screenHeight >= 896 {
            super.viewWillLayoutSubviews()
            var tabFrame: CGRect = self.tabBar.frame
            self.tabBar.frame.size.height = 55
            tabFrame.size.height = 96.6
            tabFrame.origin.y = self.view.frame.size.height - 96.6
            self.tabBar.frame = tabFrame
        }
        else if screenWidth == 375 && screenHeight == 667 {
            var tabFrame: CGRect = self.tabBar.frame
            self.tabBar.frame.size.height = 49
            tabFrame.size.height = 49
            tabFrame.origin.y = self.view.frame.size.height - 49
            self.tabBar.frame = tabFrame
        }
        else {
            var tabFrame: CGRect = self.tabBar.frame
            self.tabBar.frame.size.height = 49
            tabFrame.size.height = 80
            tabFrame.origin.y = self.view.frame.size.height - 80
            self.tabBar.frame = tabFrame
        }
    }
    
    func setTabBar() {
        let CherishMain = UIStoryboard.init(name: "CherishMain", bundle: nil)
        guard let main = CherishMain.instantiateViewController(identifier: "CherishMainVC") as? CherishMainVC else { return }
        let mainTab = NavigationController(rootViewController: main).then {
            $0.tabBarItem.image = UIImage(named: "icnHomeUnselected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
            $0.tabBarItem.selectedImage = UIImage(named: "icnHomeSelected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        }
        
        let MyPage = UIStoryboard.init(name: "MyPage", bundle: nil)
        guard let page = MyPage.instantiateViewController(identifier: "MyPageVC") as? MyPageVC  else { return }
        let pageTab = NavigationController(rootViewController: page).then {
            $0.tabBarItem.image = UIImage(named: "icnMypageUnselected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
            $0.tabBarItem.selectedImage = UIImage(named: "icnMypageSelected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        }
        
        let showMoreTab = NavigationController(rootViewController: ShowMoreVC()).then {
            $0.tabBarItem.image = UIImage(named: "icnMoreUnselected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
            $0.tabBarItem.selectedImage = UIImage(named: "icnMoreSelected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        }
        
        let tabs =  [mainTab, pageTab, showMoreTab]
        let appearance = UITabBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.shadowColor = .clear
            $0.backgroundColor = .white
        }
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        tabBar.tintColor = UIColor.cherishBlack
        tabBar.isTranslucent = false
        tabBar.layer.masksToBounds = false
        self.setViewControllers(tabs, animated: false)
    }
}
