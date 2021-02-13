//
//  BackdropVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit
import OverlayContainer

class BackdropVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        makeClearView()
        NotificationCenter.default.addObserver(self, selector: #selector(makeClearView), name: .notchMinimum, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeClearView), name: .notchMedium, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeClearView), name: .cherishPeopleCellClicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeOpacityView), name: .notchMaximum, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        makeClearView()
        NotificationCenter.default.addObserver(self, selector: #selector(makeClearView), name: .notchMinimum, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeClearView), name: .notchMedium, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeClearView), name: .cherishPeopleCellClicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeOpacityView), name: .notchMaximum, object: nil)
    }
    
    
    @objc func makeOpacityView() {
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.85)
    }
    
    @objc func makeClearView() {
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.init(white: 0, alpha: 0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .notchMinimum, object: nil)
        NotificationCenter.default.removeObserver(self, name: .cherishPeopleCellClicked, object: nil)
        NotificationCenter.default.removeObserver(self, name: .notchMedium, object: nil)
        NotificationCenter.default.removeObserver(self, name: .notchMaximum, object: nil)
    }
}
