//
//  PlantResultVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/11.
//

import UIKit

class PlantResultVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var modifierLabel: UILabel!
    @IBOutlet weak var resultPlantImgView: UIImageView!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var plantBox: UIImageView!
    @IBOutlet weak var modifierRegular: UILabel!
    @IBOutlet weak var modifierBold: UILabel!
    
    var modifier: String?
    var resultPlantImgUrl: String?
    var resultPeriod: String?
    var explanation: String?
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationSwipeGuesture()
        setPlantLabel()
//        NotificationCenter.default.addObserver(self, selector: #selector(setPlantLabel), name: .sendPlantResult, object: nil)
        // Do any additional setup after loading the view.
    }
    
    let rose: UIColor = UIColor(red: 241/255, green: 176/255, blue: 188/255, alpha: 1.0)
    let american:  UIColor = UIColor(red: 143/255, green: 149/255, blue: 175/255, alpha: 1.0)
    let min: UIColor = UIColor(red: 123/255, green: 166/255, blue: 154/255, alpha: 1.0)
    let stuiki: UIColor = UIColor(red: 136/255, green: 162/255, blue: 196/255, alpha: 1.0)
    let dan: UIColor = UIColor(red: 125/255, green: 159/255, blue: 188/255, alpha: 1.0)
    
    func goToCherishMainView(){
        let tabBarStoyboard: UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let tabBarVC = tabBarStoyboard.instantiateViewController(identifier: "CherishTabBarController") as? CherishTabBarController {
            
            self.navigationController?.pushViewController(tabBarVC, animated: true)
            self.navigationController?.setViewControllers([tabBarVC], animated: false)
        }
    }
    
    func addNavigationSwipeGuesture() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    
    @IBAction func startToMain(_ sender: UIButton) {
        appDel.isCherishAdded = true

        UserDefaults.standard.set("", forKey: "selectedNickNameData")
        UserDefaults.standard.set(0, forKey: "selectedGrowthData")
        UserDefaults.standard.set(0, forKey: "selectedGrowthData")
        UserDefaults.standard.set("", forKey: "selectedModifierData")
        UserDefaults.standard.set(true, forKey: "addUser")
        NotificationCenter.default.post(name: .addUser, object: nil)

        var userId = UserDefaults.standard.integer(forKey: "userID")
        let storyBoard: UIStoryboard = UIStoryboard(name: "CherishMain", bundle: nil)
        
        guard let dvc = storyBoard.instantiateViewController(identifier: "MainContentVC") as? MainContentVC else {return}
        

        let rootviewController = self.navigationController!.viewControllers.first
        
        print("루트뷰컨", rootviewController!)
        
        if rootviewController is SplashVC {
            print("루트 뷰컨이 LoginNC에요")
            goToCherishMainView()
        }
        else {
            print("루트 뷰컨이 TabBarController에요")
            self.navigationController?.popToRootViewController(animated: true)

        }
    }
    
    func setPlantLabel() {
        let font = UIFont(name: "Noto Sans CJK KR Bold", size: 28)
        
        // 이미지 받아오기
        let url = URL(string: UserDefaults.standard.string(forKey: "resultImgURL")!)
        print(url)
        
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: url!)
//            DispatchQueue.main.async {
//                self.resultPlantImgView.image = UIImage(data: data!)
//            }
//        }
        let data = try? Data(contentsOf: url!)
        self.resultPlantImgView.image = UIImage(data: data!)
        
//        self.modifierLabel.text = UserDefaults.standard.string(forKey: "resultModifier")
//        self.flowerMeaningLabel.text = UserDefaults.standard.string(forKey: "flowerMeaning")
        
        //label에 있는 Text를 NSMutableAttributedString으로 만들어준다.
//        let attributedStr = NSMutableAttributedString(string: self.modifierLabel.text!)
//        let modifierArr = self.modifierLabel.text?.components(separatedBy: "\n")
        let modifierArr = UserDefaults.standard.string(forKey: "resultModifier")?.components(separatedBy: "\n")
//        let modifierBold = modifierArr![1]

        //위에서 만든 attributedStr에 addAttribute메소드를 통해 Attribute를 적용. kCTFontAttributeName은 value로 폰트크기와 폰트를 받을 수 있음
//        attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String), value: font, range: (self.modifierLabel.text as! NSString).range(of: modifierBold))

        //최종적으로 내 label에 속성을 적용
//        self.modifierLabel.attributedText = attributedStr
        print("modifier")
        print(modifierArr?[0])
        print(modifierArr?[1])
        self.modifierRegular.text = modifierArr![0]
        self.modifierBold.text = modifierArr![1]
        
        self.explanationLabel.text = UserDefaults.standard.string(forKey: "resultExplanation")
        
//        addBtn.backgroundColor = .seaweed
//        addBtn.makeRounded(cornerRadius: 25.0)
        
        // 식물 종류 따라 라벨, 버튼 색깔 바꾸기
        let plantId = UserDefaults.standard.integer(forKey: "resultPlantId")
        switch plantId {
        case 1:
            // 로즈마리
//            self.startBtn.setBackgroundImage(UIImage(named: "btn_final_selected_rose"), for: .normal)
            self.plantBox.image = UIImage(named: "plant_say_rose")
            self.startBtn.backgroundColor = .rosemaryBg
            self.startBtn.makeRounded(cornerRadius: 25.0)
        case 2:
            // 아메리칸 블루
//            self.startBtn.setBackgroundImage(UIImage(named: "btn_final_selected_american"), for: .normal)
            self.plantBox.image = UIImage(named: "plant_say_blue")
            self.startBtn.backgroundColor = .americanBlueBg
            self.startBtn.makeRounded(cornerRadius: 25.0)

        case 3:
            // 민들레
//            self.startBtn.setBackgroundImage(UIImage(named: "btn_final_selected_min"), for: .normal)
            self.plantBox.image = UIImage(named: "plant_say_min")
            self.startBtn.backgroundColor = .dandelionBg
            self.startBtn.makeRounded(cornerRadius: 25.0)

        case 4:
            // 단모환
//            self.startBtn.setBackgroundImage(UIImage(named: "btn_final_selected_dan"), for: .normal)
            self.plantBox.image = UIImage(named: "plant_say_dan")
            self.startBtn.backgroundColor = .cactusBg
            self.startBtn.makeRounded(cornerRadius: 25.0)

        case 5:
            // 스투키
//            self.startBtn.setBackgroundImage(UIImage(named: "btn_final_selected_stuki"), for: .normal)
            self.plantBox.image = UIImage(named: "plant_say_stuki")
            self.startBtn.backgroundColor = .stuckyBg
            self.startBtn.makeRounded(cornerRadius: 25.0)

        default:
            return
        }
        
        viewWillAppear(false)
    }
}
