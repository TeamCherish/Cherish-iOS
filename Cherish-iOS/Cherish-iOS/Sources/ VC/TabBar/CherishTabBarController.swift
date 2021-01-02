//
//  CherishTabBarController.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit

class CherishTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
    
    
    // MARK: - 탭바 만드는 함수
    
    func setTabBar() {
        
        self.tabBar.tintColor = UIColor.black
        
        /// 메인탭
        let CherishMain = UIStoryboard.init(name: "CherishMain", bundle: nil)
        guard let firstTab = CherishMain.instantiateViewController(identifier: "CherishMainVC")
                as? CherishMainVC  else {
            return
        }
        
        firstTab.tabBarItem.image = UIImage(systemName: "house")
        firstTab.tabBarItem.selectedImage = UIImage(named: "icnHomeSelected")
        
        /// 마이페이지탭
        let MyPage = UIStoryboard.init(name: "MyPage", bundle: nil)
        guard let secondTab = MyPage.instantiateViewController(identifier: "MyPageVC")
                as? MyPageVC  else {
            return
        }
        
        secondTab.tabBarItem.image = UIImage(named: "icnMypageUnselected")
        secondTab.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        /// 더보기탭
        let ShowMore = UIStoryboard.init(name: "ShowMore", bundle: nil)
        guard let thirdTab = ShowMore.instantiateViewController(identifier: "ShowMoreVC")
                as? ShowMoreVC  else {
            return
        }
        
        thirdTab.tabBarItem.image = UIImage(named: "icnMoreUnselected")
        thirdTab.tabBarItem.selectedImage = UIImage(systemName: "ellipsis")
        
        
        let tabs =  [firstTab, secondTab, thirdTab]
        
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -3)
        tabBar.layer.shadowRadius = 3
        self.setViewControllers(tabs, animated: false)
    }
}
