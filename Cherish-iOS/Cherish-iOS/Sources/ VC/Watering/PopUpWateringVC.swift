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
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func moveToContact(_ sender: Any) {
        guard let pvc = self.presentingViewController else {return}
        self.dismiss(animated: true) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "PopUpContact", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "PopUpContactVC") as? PopUpContactVC{
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                pvc.self.present(vc, animated: true, completion: nil)
            }
        }
    }
    @IBAction func moveToLater(_ sender: Any) {
        guard let pvc = self.presentingViewController else {return}
        self.dismiss(animated: true) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "PopUpLater", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "PopUpLaterVC") as? PopUpLaterVC{
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                pvc.self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
