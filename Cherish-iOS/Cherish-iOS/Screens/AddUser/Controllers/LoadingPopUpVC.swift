//
//  LoadingPopUpVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/11.
//

import UIKit

class LoadingPopUpVC: UIViewController {
    
    @IBOutlet weak var popUpView: UIView! {
        didSet {
            popUpView.backgroundColor = .white
            popUpView.makeRounded(cornerRadius: 20)
        }
    }
    @IBOutlet weak var loadingImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingImgView.loadGif(asset: "loadingPopup")
        print("로딩중중중")
    }
}
