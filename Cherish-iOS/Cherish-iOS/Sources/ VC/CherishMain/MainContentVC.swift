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
    let backgroundWhiteView = UIView()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundWhiteView.frame = CGRect(x: 0, y: 0, width: self.view.frame.maxX, height: self.view.frame.maxY)
        backgroundWhiteView.backgroundColor = .white
        isFirstLoad += 1
        getCherishData()
        print("viewDidLoad")
        //noti 감지 후 view가 reload될 수 있도록 viewWillAppear함수를 호출해준다.
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear), name: .cherishPeopleCellClicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear), name: .postPostponed, object: nil)
        
    }
    
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        print(appDel.isWateringComplete)
        
        LoadingHUD.show()
        print("viewWillAppear")
        // cherishPeopleCell이 선택되거나
        // 물주기를 미루면 배경뷰의 라벨값, 식물이미지, 배경색을 바꿔준다.
        if appDel.isWateringPostponed == true {
            print("isWateringPostponed")
            getCherishData()
            appDel.isWateringPostponed = false
        }
        
        
        // cherishPeopleCell이 선택되면 배경뷰의 라벨값, 식물이미지, 배경색을 바꿔준다.
        if appDel.isCherishPeopleCellSelected == true || appDel.isWateringComplete == true {
            print("hhh???????")
            setMainDataViewWillApeear()
            appDel.isCherishPeopleCellSelected = false
            LoadingHUD.hide()
        }
        
        if isFirstLoad > 0 {
            
            if appDel.isCherishAdded == true {
                print("isCherishAdded")
                getCherishData()
                appDel.isCherishAdded = false
            }
            
            // 식물상세페이지로 네비게이션 연결 후 탭바가 사라지기 때문에
            // popViewController 액션으로 다시 메인뷰로 돌아왔을 때 탭바가 나타나야 한다.
            self.tabBarController?.tabBar.isHidden = false
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        backgroundWhiteView.isHidden = true
        LoadingHUD.hide()
    }
    
    
    //MARK: - 메인 뷰 데이터 받아오는 함수
    func getCherishData() {
        
        // cherishPeopleCell이 선택되지 않았을 때 첫 메인의 값을 지정해준다.
        if appDel.isCherishPeopleCellSelected == false || appDel.isWateringPostponed == true || appDel.isWateringComplete == true {
            let cherishMainUserIdx: Int = UserDefaults.standard.integer(forKey: "userID")
            
            MainService.shared.inquireMainView(idx:cherishMainUserIdx) { [self]
                (networkResult) -> (Void) in
                switch networkResult {
                case .success(let data):
                    if let mainResultData = data as? MainData {
                        cherishPeopleData = mainResultData.result
                        userNickNameLabel.text = cherishPeopleData[0].nickname
                        growthPercentLabel.text = "\(cherishPeopleData[0].growth)%"
                        customProgressBarView(cherishPeopleData[0].growth)
                        plantExplainLabel.text = cherishPeopleData[0].modifier
                        
                        /// gif 데이터가 있을 때
                        if cherishPeopleData[0].gif != "없지롱" {
                            
                            //물주기가 완료되었을 때만 물주기 모션 그래픽
                            if appDel.isWateringComplete == true {
                                plantImageView.isHidden = true
                                plantGifView.isHidden = false
                                plantGifView.image = UIImage.gif(name: "min_watering_ios")!
                                appDel.isWateringComplete = false
                            }
                            else {
                                plantImageView.isHidden = true
                                plantGifView.isHidden = false
                                plantGifView.image = UIImage.gif(name: "real_min")!
                                self.view.backgroundColor = .dandelionBg
                            }
                        }
                        /// gif 데이터가 없을 때
                        // 식물 그래픽 이미지로 대체
                        else {
                            plantGifView.isHidden = true
                            plantImageView.isHidden = false
                            
                            //Topconstant 기본값 104
                            plantImageViewTopConstraint.constant = 104
                            
                            //MARK: - 식물별 이미지 할당
                            if cherishPeopleData[0].plantName == "민들레" {
                                plantImageView.image = UIImage(named: "mainImgMin")
                                self.view.backgroundColor = .dandelionBg
                            }
                            else if cherishPeopleData[0].plantName == "단모환" {
                                plantImageView.image = UIImage(named: "mainImgSun")
                                self.view.backgroundColor = .cactusBg
                            }
                            else if cherishPeopleData[0].plantName == "스투키" {
                                plantImageView.image = UIImage(named: "mainImgStuki")
                                self.view.backgroundColor = .stuckyBg
                            }
                            else if cherishPeopleData[0].plantName == "아메리칸블루" {
                                plantImageViewTopConstraint.constant = 134
                                plantImageView.image = UIImage(named: "mainImgAmericanblue")
                                self.view.backgroundColor = .americanBlueBg
                            }
                            else if cherishPeopleData[0].plantName == "로즈마리" {
                                plantImageView.image = UIImage(named: "mainImgRosemary")
                                self.view.backgroundColor = .rosemaryBg
                            }
                        }
                        
                        /// dDay 값 파싱 -,+,0
                        if cherishPeopleData[0].dDay == 0 {
                            dayCountLabel.text = "D-day"
                        }
                        else if cherishPeopleData[0].dDay < 0 {
                            dayCountLabel.text = "D+\(-cherishPeopleData[0].dDay)"
                        }
                        else {
                            dayCountLabel.text = "D-\(cherishPeopleData[0].dDay)"
                        }
                        
                        UserDefaults.standard.set(cherishPeopleData[0].id, forKey: "selectedFriendIdData")
                        UserDefaults.standard.set(cherishPeopleData[0].phone, forKey: "selectedFriendPhoneData")
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
    
    
    //MARK: - viewWillAppear에서 메인 데이터 바꿔주는 함수 (선택된 친구 데이터로 바꿔주기)
    func setMainDataViewWillApeear(){
        self.userNickNameLabel.text = UserDefaults.standard.string(forKey: "selectedNickNameData")
        customProgressBarView(UserDefaults.standard.integer(forKey: "selectedGrowthData"))
        self.growthPercentLabel.text = "\(UserDefaults.standard.integer(forKey: "selectedGrowthData"))%"
        self.plantExplainLabel.text = UserDefaults.standard.string(forKey: "selectedModifierData")
        
        let selectedGif = UserDefaults.standard.string(forKey: "selectedGif")
        let selectedPlantName = UserDefaults.standard.string(forKey: "selectedPlantName")
        
        // gif 데이터가 있을 때
        if selectedGif != "없지롱" {
            
            //물주기가 완료되었을 때만 물주기 모션 그래픽
            if appDel.isWateringComplete == true {
                plantImageView.isHidden = true
                plantGifView.isHidden = false
                plantGifView.image = UIImage.gif(name: "min_watering_ios")!
                appDel.isWateringComplete = false
            }
            else {
                plantImageView.isHidden = true
                plantGifView.isHidden = false
                plantGifView.image = UIImage.gif(name: "real_min")!
                self.view.backgroundColor = .dandelionBg
            }
        }
        // gif 데이터가 없을 때
        // 식물 그래픽 이미지로 대체
        else {
            plantImageView.isHidden = false
            plantGifView.isHidden = true
            
            //Topconstant 기본값 104
            plantImageViewTopConstraint.constant = 104
            
            //MARK: - 선택된 친구 데이터의 식물별 이미지 할당
            if selectedPlantName == "민들레" {
                plantImageView.image = UIImage(named: "mainImgMin")
                self.view.backgroundColor = .dandelionBg
            }
            else if selectedPlantName == "단모환" {
                plantImageView.image = UIImage(named: "mainImgSun")
                self.view.backgroundColor = .cactusBg
            }
            else if selectedPlantName == "스투키" {
                plantImageView.image = UIImage(named: "mainImgStuki")
                self.view.backgroundColor = .stuckyBg
            }
            else if selectedPlantName == "아메리칸블루" {
                plantImageViewTopConstraint.constant = 134
                plantImageView.image = UIImage(named: "mainImgAmericanblue")
                self.view.backgroundColor = .americanBlueBg
            }
            else if selectedPlantName == "로즈마리" {
                plantImageView.image = UIImage(named: "mainImgRosemary")
                self.view.backgroundColor = .rosemaryBg
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
