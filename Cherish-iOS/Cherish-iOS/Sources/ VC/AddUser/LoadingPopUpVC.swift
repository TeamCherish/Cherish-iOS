//
//  LoadingPopUpVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/11.
//

import UIKit

class LoadingPopUpVC: UIViewController {
    
    @IBOutlet weak var loadingImgView: UIImageView!
    
    var mTimer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingImgView.loadGif(asset: "loading")
        sleep(5)
        mTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(moveToResultVC), userInfo: nil, repeats: false)
        // Do any additional setup after loading the view.
    }
    
    @objc func moveToResultVC() {
        guard let dvc = self.storyboard?.instantiateViewController(identifier: "PlantResultVC") as? PlantResultVC else { return }
        self.navigationController?.pushViewController(dvc, animated: true)
    }

}
