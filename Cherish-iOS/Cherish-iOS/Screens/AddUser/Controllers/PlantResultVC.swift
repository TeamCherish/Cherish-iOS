//
//  PlantResultVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/11.
//

import UIKit

class PlantResultVC: BaseController {

    @IBOutlet weak var modifierLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var resultPlantImgView: UIImageView!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var plantBox: UIImageView!
    @IBOutlet weak var modifierRegular: UILabel!
    @IBOutlet weak var modifierBold: UILabel!
    @IBOutlet weak var modifierRegularTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var startBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var startBtnTopConstraint: NSLayoutConstraint!
    
    var modifier: String?
    var resultPlantImgUrl: String?
    var resultPeriod: String?
    var explanation: String?
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let screenHeight = UIScreen.main.bounds.size.height
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setPlantLabel()
    }
    
    let rose: UIColor = UIColor(red: 241/255, green: 176/255, blue: 188/255, alpha: 1.0)
    let american:  UIColor = UIColor(red: 143/255, green: 149/255, blue: 175/255, alpha: 1.0)
    let min: UIColor = UIColor(red: 123/255, green: 166/255, blue: 154/255, alpha: 1.0)
    let stuiki: UIColor = UIColor(red: 136/255, green: 162/255, blue: 196/255, alpha: 1.0)
    let dan: UIColor = UIColor(red: 125/255, green: 159/255, blue: 188/255, alpha: 1.0)
    
    func setConstraints() {
        
        if screenHeight == 896 { //11 Pro Max, 11, Xs Max, Xr
            modifierRegularTopConstraint.constant = 65.0
            startBtnHeight.constant = 54
            startBtnTopConstraint.constant = 66
        }
        else if screenHeight == 926 { // 12 Pro Max
            modifierRegularTopConstraint.constant = 69.0
            startBtnHeight.constant = 54
            startBtnTopConstraint.constant = 66
        }
        else if screenHeight == 844 { // 12, 12 Pro
            modifierRegularTopConstraint.constant = 54.0
        }
        else if screenHeight == 736 { // 6+, 6s+, 7+, 8+
            modifierRegularTopConstraint.constant = 35.0
        }
        else if screenHeight == 667 { // 6, 6s, 7, 8, se 2
            modifierRegularTopConstraint.constant = 20.0
        }
        else if screenHeight == 780 { // 12 mini
            modifierRegularTopConstraint.constant = 43.0
        }
        else { // 812 -> 11 Pro, X, Xs
            modifierRegularTopConstraint.constant = 49.0
        }
        
        modifierRegular.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        modifierRegular.widthAnchor.constraint(equalToConstant: 269)
        modifierRegular.heightAnchor.constraint(equalToConstant: 40)
    }
    
    func goToCherishMainView(){
        let tabBarStoyboard: UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let tabBarVC = tabBarStoyboard.instantiateViewController(identifier: "CherishTabBarController") as? CherishTabBarController {
            
            self.navigationController?.pushViewController(tabBarVC, animated: true)
        }
    }

    
    @IBAction func startToMain(_ sender: UIButton) {
        appDel.isCherishAdded = true
        UserDefaults.standard.set(true, forKey: "isPlantExist")
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
        
        if rootviewController is LoginVC {
            print("루트 뷰컨이 LoginNC에요")
            goToCherishMainView()
        }
        else if rootviewController is AddUserVC {
            goToCherishMainView()
        }
        else {
            print("루트 뷰컨이 TabBarController에요")
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func setPlantLabel() {
        let font = UIFont(name: "Noto Sans CJK KR Bold", size: 28)
        
        /// 이미지 받아오기
        
        if let url = URL(string: UserDefaults.standard.string(forKey: "resultImgURL") ?? "") {
            if let data = try? Data(contentsOf: url) {
                self.resultPlantImgView.image = UIImage(data: data)
            }
        }
        
        let modifierArr = UserDefaults.standard.string(forKey: "resultModifier")?.components(separatedBy: "\n")

        self.modifierRegular.text = modifierArr?[0]
        self.modifierBold.text = modifierArr?[1]
        
        self.explanationLabel.text = UserDefaults.standard.string(forKey: "resultExplanation")
        
        // 식물 종류 따라 라벨, 버튼 색깔 바꾸기
        let plantId = UserDefaults.standard.integer(forKey: "resultPlantId")
        switch plantId {
        case 1:
            // 로즈마리
            self.plantBox.image = UIImage(named: "plant_say_rose")
            self.startBtn.backgroundColor = .rosemaryBg
            self.startBtn.makeRounded(cornerRadius: 25.0)
        case 2:
            // 아메리칸 블루
            self.plantBox.image = UIImage(named: "plant_say_blue")
            self.startBtn.backgroundColor = .americanBlueBg
            self.startBtn.makeRounded(cornerRadius: 25.0)

        case 3:
            // 민들레
            self.plantBox.image = UIImage(named: "plant_say_min")
            self.startBtn.backgroundColor = .dandelionBg
            self.startBtn.makeRounded(cornerRadius: 25.0)

        case 4:
            // 단모환
            self.plantBox.image = UIImage(named: "plant_say_dan")
            self.startBtn.backgroundColor = .stuckyBg
            self.startBtn.makeRounded(cornerRadius: 25.0)

        case 5:
            // 스투키
            self.plantBox.image = UIImage(named: "plant_say_stuki")
            self.startBtn.backgroundColor = .cactusBg
            self.startBtn.makeRounded(cornerRadius: 25.0)

        default:
            return
        }
        
        viewWillAppear(false)
    }
}
