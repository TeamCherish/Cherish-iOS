//
//  LoadingPopUpVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/11.
//

import UIKit

class LoadingPopUpVC: BaseController {
    
    @IBOutlet weak var popUpView: UIView! {
        didSet {
            popUpView.backgroundColor = .white
            popUpView.makeRounded(cornerRadius: 20)
        }
    }
    @IBOutlet weak var loadingImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blurGrey
        loadingImgView.loadGif(asset: "loadingPopup")
    }
}
