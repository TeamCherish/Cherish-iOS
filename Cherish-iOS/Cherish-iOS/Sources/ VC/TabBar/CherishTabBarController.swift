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
        guard let firstTab = CherishMain.instantiateViewController(identifier: "CherishMainNC")
                as? CherishMainNC  else {
            return
        }
        
        firstTab.tabBarItem.image = UIImage(named: "icnHomeUnselected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        firstTab.tabBarItem.selectedImage = UIImage(named: "icnHomeSelected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        
        /// 마이페이지탭
        let MyPage = UIStoryboard.init(name: "MyPage", bundle: nil)
        guard let secondTab = MyPage.instantiateViewController(identifier: "MypageNC")
                as? MypageNC  else {
            return
        }
        
        secondTab.tabBarItem.image = UIImage(named: "icnMypageUnselected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        secondTab.tabBarItem.selectedImage = UIImage(named: "icnMypageSelected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        
        /// 더보기탭
        let ShowMore = UIStoryboard.init(name: "ShowMore", bundle: nil)
        guard let thirdTab = ShowMore.instantiateViewController(identifier: "ShowMoreVC")
                as? ShowMoreVC  else {
            return
        }
        
        thirdTab.tabBarItem.image = UIImage(named: "icnMoreUnselected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        thirdTab.tabBarItem.selectedImage = UIImage(named: "icnMoreSelected")?.withAlignmentRectInsets(UIEdgeInsets(top: 9, left: 0, bottom: -8.5, right: 0))
        
        
        let tabs =  [firstTab, secondTab, thirdTab]
        
        tabBar.layer.shadowOpacity = 0
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.barTintColor = .white
        self.setViewControllers(tabs, animated: false)
    }
}
