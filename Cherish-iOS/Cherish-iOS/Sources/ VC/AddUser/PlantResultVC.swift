//
//  PlantResultVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/11.
//

import UIKit

class PlantResultVC: UIViewController {

    @IBOutlet weak var modifierLabel: UILabel!
    @IBOutlet weak var resultPlantImgView: UIImageView!
    @IBOutlet weak var resultPeriodLabel: CustomLabel!
    @IBOutlet weak var explanationLabel: UILabel!
    
    var modifier: String?
    var resultPlantImgUrl: String?
    var resultPeriod: String?
    var explanation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func startToMain(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setLabel() {
        if let modifier = self.modifier,
           let resultPlantImgUrl = self.resultPlantImgUrl,
           let resultPeriod = self.resultPeriod,
           let explanation = self.explanation {
            self.modifierLabel.text = modifier
            self.resultPeriodLabel.text = resultPeriod
            self.explanationLabel.text = explanation
        }
    }

}
