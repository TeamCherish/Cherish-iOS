//
//  PopUpWatering_WithoutLaterVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/26.
//

import UIKit

class PopUpWatering_WithoutLaterVC: BaseController {
    //MARK: -@IBOutlet
    @IBOutlet weak var popupWithoutLaterView: UIView!
    @IBOutlet weak var wateringBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blurGrey
        setStyle()
    }
    
    // 뒤로가기 버튼
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // 물주기 버튼
    @IBAction func goToWatering(_ sender: Any) {
        guard let pvc = self.presentingViewController else {return}
        self.dismiss(animated: true) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "PopUpContact", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "PopUpContactVC") as? PopUpContactVC{
                vc.modalPresentationStyle = .overFullScreen ///탭바까지 Alpha값으로 덮으면서 팝업뷰
                vc.modalTransitionStyle = .crossDissolve
                pvc.self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func setStyle() {
        popupWithoutLaterView.dropShadow(color: UIColor.blue, offSet: CGSize(width: 0, height: 4), opacity: 0.25, radius: 4)
        popupWithoutLaterView.makeRounded(cornerRadius: 20.0)
        wateringBtn.makeRounded(cornerRadius: 25.0)
    }
}
