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
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlantLabel()
//        NotificationCenter.default.addObserver(self, selector: #selector(setPlantLabel), name: .sendPlantResult, object: nil)
        // Do any additional setup after loading the view.
    }

    @IBAction func startToMain(_ sender: Any) {
        appDel.isCherishAdded = true
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setPlantLabel() {
        print("hi")
        
        let font = UIFont(name: "Noto Sans CJK KR Bold", size: 28)
        
        self.modifierLabel.text = UserDefaults.standard.string(forKey: "resultModifier")
        
        
        //label에 있는 Text를 NSMutableAttributedString으로 만들어준다.
        let attributedStr = NSMutableAttributedString(string: self.modifierLabel.text!)

        
        let modifierArr = self.modifierLabel.text?.components(separatedBy: "\n")
        
        let modifierBold = modifierArr![1]

        //위에서 만든 attributedStr에 addAttribute메소드를 통해 Attribute를 적용. kCTFontAttributeName은 value로 폰트크기와 폰트를 받을 수 있음
        attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String), value: font, range: (self.modifierLabel.text as! NSString).range(of: modifierBold))

        //최종적으로 내 label에 속성을 적용
        self.modifierLabel.attributedText = attributedStr
        
        self.explanationLabel.text = UserDefaults.standard.string(forKey: "resultExplanation")
        viewWillAppear(false)
    }
}
