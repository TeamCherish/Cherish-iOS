//
//  LoadingPopUpVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/11.
//

import UIKit

class LoadingPopUpVC: UIViewController {
    
    @IBOutlet weak var loadingImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingImgView.loadGif(asset: "loading")
        // Do any additional setup after loading the view.
    }

}
