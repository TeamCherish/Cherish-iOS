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
    
    var mTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingImgView.loadGif(asset: "loadingPopup")
        print("로딩중중중")
//        mTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(moveToResultVC), userInfo: nil, repeats: false)
//        print("왜 안넘어가징")
        // Do any additional setup after loading the view.
    }
    
//    @objc func moveToResultVC() {
//        guard let dvc = self.storyboard?.instantiateViewController(identifier: "PlantResultVC") as? PlantResultVC else { return }
//        self.navigationController?.pushViewController(dvc, animated: true)
//    }
}
