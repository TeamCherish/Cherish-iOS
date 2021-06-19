//
//  AddUserSplashVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/06/19.
//

import UIKit

class AddUserSplashVC: UIViewController {
    
    var isFirstLoaded: Bool = false
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenTabNaviBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        //자동로그인 시
        if appDel.isLoginManually == false {
            
            self.view.layoutIfNeeded()
            self.logoImageView.alpha = 0.0

             UIView.animate(withDuration: 3.0, animations:
            {
                self.logoImageView.alpha = 1.0
                self.view.layoutIfNeeded()
            },completion: {finished in
             
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                 let vc = (self.storyboard?.instantiateViewController(identifier: "NoPlantVC"))! as NoPlantVC
                 
                 self.navigationController?.pushViewController(vc, animated: false)
                 
                 // 스플래시 후 CherishMainVC로 push를 하고나서 루트 뷰컨을 CherishMainVC로 변경해줌
                 // --> 홈탭이 눌려도 스플래시뷰로 이동되지 않게 아예 루트뷰컨을 변경한 것임
                 self.navigationController?.setViewControllers([vc], animated: false)
             }
            })
        }
        //수동로그인 시
        else {
            let vc = (self.storyboard?.instantiateViewController(identifier: "NoPlantVC"))! as NoPlantVC
            
            self.navigationController?.pushViewController(vc, animated: false)
            
            // 스플래시 후 CherishMainVC로 push를 하고나서 루트 뷰컨을 CherishMainVC로 변경해줌
            // --> 홈탭이 눌려도 스플래시뷰로 이동되지 않게 아예 루트뷰컨을 변경한 것임
            self.navigationController?.setViewControllers([vc], animated: false)
            
        }
    }
    
    func hiddenTabNaviBar() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
}
