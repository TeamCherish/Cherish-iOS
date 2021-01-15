//
//  MainContentVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit


class MainContentVC: UIViewController {
    
    @IBOutlet var dayCountLabel: UILabel!
    @IBOutlet var plantExplainLabel: CustomLabel!
    @IBOutlet var userNickNameLabel: CustomLabel!
    @IBOutlet var plantGifView: UIImageView!
    @IBOutlet var plantImageView: UIImageView!
    @IBOutlet var progressbarView: ProgressBarView!
    @IBOutlet var progressbarBackView: ProgressBarView!
    @IBOutlet var growthPercentLabel: CustomLabel!
    @IBOutlet var plantImageViewTopConstraint: NSLayoutConstraint!
    var cherishPeopleData:[ResultData] = [] 
    var isFirstLoad:Int = 0
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        isFirstLoad += 1
        setDataWithSelectedData()
        
        //noti 감지 후 view가 reload될 수 있도록 viewWillAppear함수를 호출해준다.
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear), name: .cherishPeopleCellClicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear), name: .postPostponed, object: nil)
        
    }
    
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        print(appDel.isWateringPostponed)
        print(appDel.isWateringComplete)
        LoadingHUD.show()
        
        // cherishPeopleCell이 선택되면 배경뷰의 라벨값, 식물이미지, 배경색을 바꿔준다.
        if appDel.isCherishPeopleCellSelected == true || appDel.isWateringComplete == true || appDel.isWateringPostponed == true {
            
            appDel.isCherishPeopleCellSelected = true
            setDataWithSelectedData()
            LoadingHUD.hide()
        }
        
        if isFirstLoad > 0 {
            
            if appDel.isCherishAdded == true {
                print("isCherishAdded")
                setDataWithSelectedData()
                appDel.isCherishAdded = false
            }
            
            // 식물상세페이지로 네비게이션 연결 후 탭바가 사라지기 때문에
            // popViewController 액션으로 다시 메인뷰로 돌아왔을 때 탭바가 나타나야 한다.
            self.tabBarController?.tabBar.isHidden = false
            
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        LoadingHUD.hide()
    }
    
    
    //selectedData를 갖고 실제로 view를 구성하는 함수
    func setDataWithSelectedData() {
        
        if appDel.isCherishPeopleCellSelected == true {
            
            var growthInfo:Int = UserDefaults.standard.integer(forKey: "selectedGrowthData")
            self.userNickNameLabel.text = UserDefaults.standard.string(forKey: "selectedNickNameData")
            customProgressBarView(UserDefaults.standard.integer(forKey: "selectedGrowthData"))
            self.growthPercentLabel.text = "\(UserDefaults.standard.integer(forKey: "selectedGrowthData"))%"
            self.plantExplainLabel.text = UserDefaults.standard.string(forKey: "selectedModifierData")
            
            let selectedGif = UserDefaults.standard.string(forKey: "selectedGif")
            let selectedPlantName = UserDefaults.standard.string(forKey: "selectedPlantName")
            let selectedBg = UserDefaults.standard.string(forKey: "selectedMainBg") ?? ""
            let selectedFriendsIdx = UserDefaults.standard.integer(forKey: "selectedFriendIdData")
            let postponedIdx = UserDefaults.standard.integer(forKey: "postponedIdData")
            
            
            // gif 데이터가 있을 때
            // 민들레일 때
            if selectedPlantName == "민들레" {
                view.backgroundColor = .dandelionBg
                
                //물주기가 완료되었을 때만 물주기 모션 그래픽
                if appDel.isWateringComplete == true {
                    plantImageView.isHidden = true
                    plantGifView.isHidden = false
                   
                        self.plantGifView.image = UIImage.gif(name: "min_watering_ios")!
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.05) {
                        self.plantGifView.image = UIImage.gif(name: "real_min")!
                    }
                    
                    // 미루기가 진행중이고, 선택한 친구가 미루기를 한 친구일 때
                    if !(appDel.isWateringPostponed == true && postponedIdx == selectedFriendsIdx) {
                        // 미루기가 진행중이고, 선택한 친구가 미루기를 한 친구일 때
                        //watering을 true로
                        appDel.isWateringComplete = false
                    }
                }
                //물주기 미뤘을 때 시든상태
                else if appDel.isWateringPostponed == true && postponedIdx == selectedFriendsIdx {
                    print("미루기 옵니까???")
                    
                    if appDel.isWateringComplete == false {
                        plantImageView.isHidden = true
                        plantGifView.isHidden = false
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.plantGifView.image = UIImage.gif(name: "die_min_iOS")!
                        })
                        self.view.backgroundColor = .gray
                    }
                    else {
                        appDel.isWateringPostponed = false
                    }
                }
                //default
                else {
                    print("여기니?디폴트")
                    plantImageView.isHidden = false
                    plantGifView.isHidden = false
                    
                    // 식물3단계 파싱해주기
                    if growthInfo < 25 {
                        // 1단계
                        plantGifView.isHidden = true
                        self.plantImageView.image = UIImage(named: "dandelion1")
                        view.backgroundColor = .dandelionBg
                    }
                    else if growthInfo < 50 && growthInfo > 25 {
                        // 2단계
                        plantGifView.isHidden = true
                        self.plantImageView.image = UIImage(named: "dandelion2")
                        view.backgroundColor = .dandelionBg
                    }
                    else {
                        plantImageView.isHidden = true
                        // 3단계
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.plantGifView.image = UIImage.gif(name: "real_min")!
                        })
                        self.view.backgroundColor = .dandelionBg
                    }
                }
            }
            
            // gif 데이터가 없을 때
            // 식물 그래픽 이미지로 대체
            // 서버통신
            else {
                plantImageView.isHidden = false
                plantGifView.isHidden = true
                
                if selectedPlantName == "아메리칸블루" {
                    plantImageViewTopConstraint.constant = 134
                    self.plantImageView.image = UIImage(named: "mainImgAmericanblue")
                    view.backgroundColor = .americanBlueBg
                }
                else if selectedPlantName == "단모환" {
                    plantImageViewTopConstraint.constant = 104
                    self.plantImageView.image = UIImage(named: "mainImgSun")
                    view.backgroundColor = .cactusBg
                }
                else if selectedPlantName == "로즈마리" {
                    plantImageViewTopConstraint.constant = 104
                    self.plantImageView.image = UIImage(named: "mainImgRosemary")
                    view.backgroundColor = .rosemaryBg
                }
                else {
                    plantImageViewTopConstraint.constant = 104
                    
                    // 식물3단계 파싱해주기
                    if growthInfo < 25 {
                        // 1단계
                        self.plantImageView.image = UIImage(named: "stucky1")
                        view.backgroundColor = .dandelionBg
                    }
                    else if growthInfo < 50 && growthInfo > 25 {
                        // 2단계
                        self.plantImageView.image = UIImage(named: "stucky2")
                        view.backgroundColor = .dandelionBg
                    }
                    else {
                        // 3단계
                        self.plantImageView.image = UIImage(named: "mainImgStuki")
                        self.view.backgroundColor = .dandelionBg
                    }
                    view.backgroundColor = .stuckyBg
                }
            }
            
            //MARK: - 선택된 친구 데이터의 dDay 값 파싱 -,+,0
            if UserDefaults.standard.integer(forKey: "selecteddDayData") == 0 {
                self.dayCountLabel.text = "D-day"
            }
            else if UserDefaults.standard.integer(forKey: "selecteddDayData") < 0 {
                self.dayCountLabel.text = "D+\(-UserDefaults.standard.integer(forKey: "selecteddDayData"))"
            }
            else {
                self.dayCountLabel.text = "D-\(UserDefaults.standard.integer(forKey: "selecteddDayData"))"
            }
            appDel.isCherishPeopleCellSelected = false
        }
    }
    
    //MARK: - 프로그레스바 커스텀
    func customProgressBarView(_ value : Int) {
        progressbarBackView.setBackColor(color: .white)
        progressbarView.setBackColor(color: .white)
        
        if value < 50 {
            progressbarView.setProgressColor(color: .pinkSub)
        }
        else {
            progressbarView.setProgressColor(color: .seaweed)
        }
        progressbarView.setProgressValue(currentValue: CGFloat(value))
    }
    
    
    //MARK: - 식물 상세페이지 뷰로 이동
    @IBAction func moveToPlantDetailView(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "PlantDetail", bundle: nil)
        if let vc = storyBoard.instantiateViewController(identifier: "PlantDetailVC") as? PlantDetailVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - 물주기 팝업뷰로 이동
    @IBAction func moveToWateringPopUp(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "PopUpWatering", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "PopUpWateringVC") as? PopUpWateringVC{
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
}

class LoadingHUD: NSObject {
    private static let sharedInstance = LoadingHUD()
    private var backgroundView: UIView?
    private var popupView: UIView?
    private var popupImageView: UIImageView?
    
    class func show() {
        if let window = UIApplication.shared.keyWindow {
            let backgroundView = UIView()
            let popupView = UIView()
            let popupImageView = UIImageView()
            let w = UIScreen.main.bounds.width
            let h = UIScreen.main.bounds.height
            popupView.frame = CGRect(x:0, y: 0, width: 80, height: 80)
            popupView.center = window.center
            popupView.layer.cornerRadius = 20
            backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.maxX, height: window.frame.maxY)
            // 윈도우의 크기에 맞춰 설정
            backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            popupView.backgroundColor = UIColor.white
            popupImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 58)
            popupImageView.center = window.center
            popupImageView.image = LoadingHUD.getAnimationImage()
            popupImageView.animationDuration = 4.0
            popupImageView.animationRepeatCount = 0
            
            window.addSubview(backgroundView)
            window.addSubview(popupView)
            window.addSubview(popupImageView)
            sharedInstance.popupImageView?.removeFromSuperview()
            sharedInstance.popupView?.removeFromSuperview()
            sharedInstance.backgroundView?.removeFromSuperview()
            sharedInstance.popupView = popupView
            sharedInstance.backgroundView = backgroundView
            sharedInstance.popupImageView = popupImageView
        }
    }
    
    class func hide() {
        if let popupView = sharedInstance.popupView {
            popupView.removeFromSuperview()
        }
        if let backgroundView = sharedInstance.backgroundView {
            backgroundView.removeFromSuperview()
        }
        if let popupImageView = sharedInstance.popupImageView {
            popupImageView.stopAnimating()
            popupImageView.removeFromSuperview()
        }
    }
    
    private class func getAnimationImage() -> UIImage {
        let animationArray: UIImage = UIImage.gif(asset: "loading")!
        
        return animationArray
    }
}
