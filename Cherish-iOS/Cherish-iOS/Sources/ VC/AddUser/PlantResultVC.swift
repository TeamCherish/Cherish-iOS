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
    @IBOutlet weak var meaningLabel: CustomLabel!
    @IBOutlet weak var flowerMeaningLabel: CustomLabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var plantBox: UIImageView!
    
    var modifier: String?
    var resultPlantImgUrl: String?
    var resultPeriod: String?
    var explanation: String?
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var checkInitial: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlantLabel()
        if checkInitial != "initial" {
            print("nil이네요 0 넣겠슴다")
            checkInitial = "not Initial"
        }
        print("결과뷰")
        print(checkInitial)
//        NotificationCenter.default.addObserver(self, selector: #selector(setPlantLabel), name: .sendPlantResult, object: nil)
        // Do any additional setup after loading the view.
    }
    
    let rose: UIColor = UIColor(red: 241/255, green: 176/255, blue: 188/255, alpha: 1.0)
    let american:  UIColor = UIColor(red: 143/255, green: 149/255, blue: 175/255, alpha: 1.0)
    let min: UIColor = UIColor(red: 123/255, green: 166/255, blue: 154/255, alpha: 1.0)
    let stuiki: UIColor = UIColor(red: 136/255, green: 162/255, blue: 196/255, alpha: 1.0)
    let dan: UIColor = UIColor(red: 125/255, green: 159/255, blue: 188/255, alpha: 1.0)

    
    @IBAction func startToMain(_ sender: Any) {
        appDel.isCherishAdded = true

        if self.checkInitial == "initial" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "CherishMain", bundle: nil)
            guard let dvc = storyBoard.instantiateViewController(identifier: "MainContentVC") as? MainContentVC else {return}
            self.navigationController?.pushViewController(dvc, animated: true)
        }
        else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func setPlantLabel() {
        let font = UIFont(name: "Noto Sans CJK KR Bold", size: 28)
        
        // 이미지 받아오기
        let url = URL(string: UserDefaults.standard.string(forKey: "resultImgURL")!)
        print(url)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.resultPlantImgView.image = UIImage(data: data!)
            }
        }
        
        self.modifierLabel.text = UserDefaults.standard.string(forKey: "resultModifier")
        self.flowerMeaningLabel.text = UserDefaults.standard.string(forKey: "flowerMeaning")
        
        //label에 있는 Text를 NSMutableAttributedString으로 만들어준다.
        let attributedStr = NSMutableAttributedString(string: self.modifierLabel.text!)
        let modifierArr = self.modifierLabel.text?.components(separatedBy: "\n")
        let modifierBold = modifierArr![1]

        //위에서 만든 attributedStr에 addAttribute메소드를 통해 Attribute를 적용. kCTFontAttributeName은 value로 폰트크기와 폰트를 받을 수 있음
        attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String), value: font, range: (self.modifierLabel.text as! NSString).range(of: modifierBold))

        //최종적으로 내 label에 속성을 적용
        self.modifierLabel.attributedText = attributedStr
        self.explanationLabel.text = UserDefaults.standard.string(forKey: "resultExplanation")
        
        // 식물 종류 따라 라벨, 버튼 색깔 바꾸기
        let plantId = UserDefaults.standard.integer(forKey: "resultPlantId")
        switch plantId {
        case 1:
            // 로즈마리
            self.startBtn.setBackgroundImage(UIImage(named: "btn_final_selected_rose"), for: .normal)
            self.meaningLabel.textColor = self.rose
            self.flowerMeaningLabel.textColor = self.rose
            self.plantBox.image = UIImage(named: "plant_tip_box_rose")
        case 2:
            // 아메리칸 블루
            self.startBtn.setBackgroundImage(UIImage(named: "btn_final_selected_american"), for: .normal)
            self.meaningLabel.textColor = self.american
            self.flowerMeaningLabel.textColor = self.american
            self.plantBox.image = UIImage(named: "plant_tip_box_american")
        case 3:
            // 민들레
            self.startBtn.setBackgroundImage(UIImage(named: "btn_final_selected_min"), for: .normal)
            self.meaningLabel.textColor = self.min
            self.flowerMeaningLabel.textColor = self.min
            self.plantBox.image = UIImage(named: "plant_tip_box_min")
        case 4:
            // 단모환
            self.startBtn.setBackgroundImage(UIImage(named: "btn_final_selected_dan"), for: .normal)
            self.meaningLabel.textColor = self.dan
            self.flowerMeaningLabel.textColor = self.dan
            self.plantBox.image = UIImage(named: "plant_tip_dan")
        case 5:
            // 스투키
            self.startBtn.setBackgroundImage(UIImage(named: "btn_final_selected_stuki"), for: .normal)
            self.meaningLabel.textColor = self.stuiki
            self.flowerMeaningLabel.textColor = self.stuiki
            self.plantBox.image = UIImage(named: "plant_tip_box_stuki")
        default:
            return
        }
        
        viewWillAppear(false)
    }
}
