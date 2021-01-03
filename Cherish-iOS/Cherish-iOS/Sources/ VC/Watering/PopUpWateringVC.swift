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
            wateringBtn.makeRounded(cornerRadius: 30.0)
        }
    }
    @IBOutlet weak var laterBtn: UIButton!{
        didSet{
            laterBtn.tintColor = .veryLightGrey
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
