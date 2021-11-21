//
//  CherishTabBarController.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit

class CherishTabBarController: UITabBarController {

    // 뷰 전체 폭 길이
    let screenWidth = UIScreen.main.bounds.size.width
    
    // 뷰 전체 높이 길이
    let screenHeight = UIScreen.main.bounds.size.height
    
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
    
    // MARK: - 탭바 만드는 함수
    
    func setTabBar() {
        
        self.tabBar.tintColor = UIColor.black
        
        
        // 메인탭
        let CherishMain = UIStoryboard.init(name: "CherishMain", bundle: nil)
        let firstTab = UINavigationController(rootViewController: (CherishMain.instantiateViewController(identifier: "CherishMainVC") as? CherishMainVC)!)
        firstTab.navigationController?.navigationBar.isHidden = true
        firstTab.tabBarItem.image = UIImage(named: "icnHomeUnselected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        firstTab.tabBarItem.selectedImage = UIImage(named: "icnHomeSelected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        
        // 마이페이지탭
        let MyPage = UIStoryboard.init(name: "MyPage", bundle: nil)
        guard let secondTab = MyPage.instantiateViewController(identifier: "MypageNC") as? MypageNC  else { return }
        secondTab.tabBarItem.image = UIImage(named: "icnMypageUnselected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        secondTab.tabBarItem.selectedImage = UIImage(named: "icnMypageSelected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        
        // 더보기탭
        let thirdTab = UINavigationController(rootViewController: ShowMoreVC())
        thirdTab.tabBarItem.image = UIImage(named: "icnMoreUnselected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        thirdTab.tabBarItem.selectedImage = UIImage(named: "icnMoreSelected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        
        let tabs =  [firstTab, secondTab, thirdTab]
        
        tabBar.layer.shadowOpacity = 0
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.barTintColor = .white
        self.setViewControllers(tabs, animated: false)
    }
}
