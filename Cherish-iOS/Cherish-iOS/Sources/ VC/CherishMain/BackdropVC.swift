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
        makeOpacityView()
    }
    
    func makeOpacityView() {
        view = PassThroughView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.85)
    }
}
