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
    var cherishPeopleData:[ResultData] = []
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        getCherishData()
        NotificationCenter.default.addObserver(self, selector: #selector(changeBackgroundInfo), name: .cherishPeopleCellClicked, object: nil)
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        // cherishPeopleCell이 선택되면 배경뷰의 라벨값, 식물이미지, 배경색을 바꿔준다.
        if appDel.isCherishPeopleCellSelected == true {
            setMainDataViewWillApeear()
        }
        
        // 식물상세페이지로 네비게이션 연결 후 탭바가 사라지기 때문에
        // popViewController 액션으로 다시 메인뷰로 돌아왔을 때 탭바가 나타나야 한다.
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: - 메인 뷰 데이터 받아오는 함수
    func getCherishData() {
        
        // herishPeopleCell이 선택되지 않았을 때 첫 메인의 값을 지정해준다.
        if appDel.isCherishPeopleCellSelected == false {
            
            MainService.shared.inquireMainView(idx: UserDefaults.standard.integer(forKey: "userID")) { [self]
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
                            plantImageView.isHidden = true
                            plantGifView.isHidden = false
                            plantGifView.loadGif(name: "real_min")
                            self.view.backgroundColor = .dandelionBg
                        }
                        /// gif 데이터가 없을 때
                        // 식물 그래픽 이미지로 대체
                        else {
                            plantGifView.isHidden = true
                            plantImageView.isHidden = false
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
        
        var selectedGif = UserDefaults.standard.string(forKey: "selectedGif")
        var selectedPlantName = UserDefaults.standard.string(forKey: "selectedPlantName")
        
        // gif 데이터가 있을 때
        if selectedGif != "없지롱" {
            plantImageView.isHidden = true
            plantGifView.isHidden = false
            plantGifView.loadGif(name: "real_min")
            self.view.backgroundColor = .dandelionBg
        }
        // gif 데이터가 없을 때
        // 식물 그래픽 이미지로 대체
        else {
            plantImageView.isHidden = false
            plantGifView.isHidden = true
            
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
                plantImageView.image = UIImage(named: "mainImgAmericanblue")
                self.view.backgroundColor = .americanBlueBg
            }
            else if selectedPlantName == "로즈마리" {
                plantImageView.image = UIImage(named: "mainImgRosemary")
                self.view.backgroundColor = .rosemaryBg
            }
        }
        
        
        
        
        /// dDay 값 파싱 -,+,0
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
    
//
//
//    //MARK:- 메인뷰 애니메이션
//    func makeAnimation() {
//        self.flowerAnimationImageView.frame = CGRect(x: 112.33, y: 291.33, width: 56, height: 61.33)
//
//        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse] , animations: {
//            self.flowerAnimationImageView.frame = CGRect(x: 105, y: 290, width: 56, height: 61.33)
//        }) { (completed) in
//        }
//    }
    
    
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
    
    
    @objc func changeBackgroundInfo() {
        
        //noti 감지 후 view가 reload될 수 있도록 viewWillAppear함수를 호출해준다.
        viewWillAppear(false)
    }
}
