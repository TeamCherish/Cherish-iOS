//
//  BackdropVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit
import OverlayContainer

class BackdropVC: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        makeClearView()
        makeNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeClearView()
        makeNotificationCenter()
    }
    
    // make notification Observer
    func makeNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(makeClearView), name: .notchMinimum, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeClearView), name: .notchMedium, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeClearView), name: .cherishPeopleCellClicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeOpacityView), name: .notchMaximum, object: nil)
    }
    
    /// 불투명한 뒷배경 뷰를 만드는 함수
    @objc func makeOpacityView() {
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.85)
    }
    
    /// 투명한 뷰를 만드는 함수
    @objc func makeClearView() {
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.init(white: 0, alpha: 0)
    }
    
    /// 뷰가 사라질 때 notification 제거해주는 함수
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .notchMinimum, object: nil)
        NotificationCenter.default.removeObserver(self, name: .cherishPeopleCellClicked, object: nil)
        NotificationCenter.default.removeObserver(self, name: .notchMedium, object: nil)
        NotificationCenter.default.removeObserver(self, name: .notchMaximum, object: nil)
    }
}
