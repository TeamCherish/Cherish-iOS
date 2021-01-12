//
//  PopUpWateringVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/03.
//

import UIKit

class PopUpWateringVC: UIViewController {
    //MARK: -@IBOutlet
    @IBOutlet weak var popupWaterView: UIView!{
        didSet{
            popupWaterView.dropShadow(color: UIColor.blue, offSet: CGSize(width: 0, height: 4), opacity: 0.25, radius: 4)
            popupWaterView.makeRounded(cornerRadius: 20.0)
        }
    }
    @IBOutlet weak var gominLabel: CustomLabel!{
        didSet{
            gominLabel.textColor = .alphaGrey
        }
    }
    @IBOutlet weak var wateringBtn: UIButton!{
        didSet{
            wateringBtn.makeRounded(cornerRadius: 25.0)
        }
    }
    @IBOutlet weak var laterBtn: UIButton!{
        didSet{
            laterBtn.setTitleColor(.textGrey, for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /// 다음에 할게요 선택시 1~7일 선택 팝업으로 이동
    func goToLatering(){
        guard let pvc = self.presentingViewController else {return}
        self.dismiss(animated: true) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "PopUpLater", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "PopUpLaterVC") as? PopUpLaterVC{
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                pvc.self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 물주기 버튼
    @IBAction func moveToContact(_ sender: Any) {
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
    
    /// 다음에할게요 버튼
    @IBAction func moveToLater(_ sender: Any) {
        /// 선택한 사람에 대해서 물주기 횟수를 체크
        //UserDefaults.standard.integer(forKey: "selectedFriendsIdData")
        LaterService.shared.checkLater(id: 5) { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                self.goToLatering()
                if let checkData = data as? LaterCheckData {
                    UserDefaults.standard.set(checkData.cherish.waterDate, forKey: "wateringDate")
                    UserDefaults.standard.set(checkData.cherish.postponeNumber, forKey: "laterNumUntilNow")
                    UserDefaults.standard.set(checkData.isLimitPostponeNumber, forKey: "noMinusisPossible")
                }
                
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}


