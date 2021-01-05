//
//  MyPageVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit

class MyPageVC: UIViewController {
    
    @IBOutlet var mypageUserImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeStatusBarBackgroundColor()
        setImageViewRounded()
    }
    
    //MARK: - 상태바 백그라운드 컬러 변경
    func changeStatusBarBackgroundColor(){
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.mypageBackgroundGrey
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
    }
    
    //MARK: - 프로필 이미지 뷰 round 처리
    func setImageViewRounded(){
        mypageUserImageView.clipsToBounds = true
        mypageUserImageView.layer.cornerRadius = mypageUserImageView.frame.height / 2
    }
}

