//
//  MainContentVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit
import Kingfisher


class MainContentVC: UIViewController {
    
    @IBOutlet var dayCountLabel: UILabel!
    @IBOutlet var plantExplainLabel: CustomLabel!
    @IBOutlet var userNickNameLabel: CustomLabel!
    @IBOutlet var plantGifView: AnimatedImageView!
    @IBOutlet var plantImageView: UIImageView!
    @IBOutlet var progressbarView: ProgressBarView!
    @IBOutlet var progressbarBackView: ProgressBarView!
    @IBOutlet var growthPercentLabel: CustomLabel!
    @IBOutlet var plantImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var plantImageViewHeight: NSLayoutConstraint!
    @IBOutlet var plantImageViewLeading: NSLayoutConstraint!
    @IBOutlet var plantImageViewTrailing: NSLayoutConstraint!
    @IBOutlet var progressViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var progressInnerViewTopConstraint: NSLayoutConstraint!
    var cherishPeopleData:[ResultData] = []
    var cherishResultData:[MainPlantConditionData] = []
    var selectedRowIndexPath:Int = 0
    @IBOutlet var blurBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurBtn: UIVisualEffectView!{
        didSet{
            blurBtn.makeRounded(cornerRadius: 14.0)
        }
    }
    let userId: Int = UserDefaults.standard.integer(forKey: "userID")
    var growthInfo:Int = UserDefaults.standard.integer(forKey: "selectedGrowthData")
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        whenNotReviewPresentToReviewVC()
        LoadingHUD.show()
        print(UserDefaults.standard.bool(forKey: "plantIsSelected"))
        UserDefaults.standard.set(false, forKey: "plantIsSelected")
        UserDefaults.standard.set(false, forKey: "calendarPlantIsSelected")
        addNotificationObserver()
        setDataWithSelectedData()
        setAutolayout()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        LoadingHUD.show()
        
        // 식물카드로 넘어갈 때 경우의 수 나누기 위해 false로 바꾼다.
        UserDefaults.standard.set(false, forKey: "plantIsSelected")
        
        // cherishPeopleCell이 선택되면 배경뷰의 라벨값, 식물이미지, 배경색을 바꿔준다.
        if appDel.isCherishPeopleCellSelected == true {
            setDataWithSelectedData()
        }
        
        if appDel.isCherishDeleted == true {
            setDataWithSelectedData()
        }
        
        if appDel.isCherishPostponed == true {
            print("미루기 함!")
            setDataWithSelectedData()
            appDel.isCherishPostponed = false
        }
        
        // 식물 삭제 후 남은 식물이 한개도 없을 때, 추가된 subView를 식물 등록 후에 remove
        if UserDefaults.standard.bool(forKey: "addUser") == true {
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
                UserDefaults.standard.set(false, forKey: "addUser")
                view.backgroundColor = .white
            }
        }
        
        // 식물상세페이지로 네비게이션 연결 후 탭바가 사라지기 때문에
        // popViewController 액션으로 다시 메인뷰로 돌아왔을 때 탭바가 나타나야 한다.
        self.tabBarController?.tabBar.isHidden = false
        
        UserDefaults.standard.set(false, forKey: "plantIsSelected")
        LoadingHUD.hide()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LoadingHUD.hide()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        view.backgroundColor = .white
    }
    
    func whenNotReviewPresentToReviewVC() {
        if (UserDefaults.standard.bool(forKey: "reviewNotYet") == true) {
            print("첫 로드 : 리뷰등록뷰")
            
            let reviewStoryboard: UIStoryboard = UIStoryboard(name: "Review", bundle: nil)
            if let reviewVC = reviewStoryboard.instantiateViewController(withIdentifier: "ReviewVC") as? ReviewVC{
                reviewVC.modalPresentationStyle = .fullScreen
                reviewVC.modalTransitionStyle = .crossDissolve
                self.present(reviewVC, animated: true, completion: nil)
            }
        }
    }
    
    
    //MARK: - addObserver Noti
    func addNotificationObserver() {
        //noti 감지 후 view가 reload될 수 있도록 viewWillAppear함수를 호출해준다.
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear), name: .cherishPeopleCellClicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear), name: .postPostponed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isWateringReported), name: .wateringReport, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getPeopleData), name: .sendPeopleDataArray, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clickPushToMoveWateringPopup), name: .pushClickToWateringPopUp, object: nil)
    }
    
    
    //MARK: - selectedData를 갖고 실제로 view를 구성하는 함수
    func setDataWithSelectedData() {
        LoadingHUD.show()
        
        if appDel.isCherishPeopleCellSelected == true {
            
            //식물 삭제했는데, 삭제하기 전 메인의 데이터가 1개였으면 삭제 후에는 식물이 0개인 것임. MainContentVC에서는 식물데이터 통신을 하지 않으므로 조건문으로 식별
            if appDel.isCherishDeleted == true && cherishResultData.count == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { [self] in
                    let whiteView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
                    whiteView.backgroundColor = .white
                    whiteView.alpha = 1.0
                    whiteView.tag = 100
                    whiteView.isUserInteractionEnabled = true
                    self.view.addSubview(whiteView)
                }
            }
            
            else {
                // IBOutlet에 값 할당
                DispatchQueue.main.async {
                    self.userNickNameLabel.text = UserDefaults.standard.string(forKey: "selectedNickNameData")
                    self.customProgressBarView(UserDefaults.standard.integer(forKey: "selectedGrowthData"))
                    self.growthPercentLabel.text = "\(UserDefaults.standard.integer(forKey: "selectedGrowthData"))%"
                    self.plantExplainLabel.text = UserDefaults.standard.string(forKey: "selectedModifierData")
                }
            }
            
            appDel.isCherishDeleted = false
            
            // 변수에 값 할당
            var selectedPlantName = UserDefaults.standard.string(forKey: "selectedPlantName")
            let selectedRowIndexPath = UserDefaults.standard.integer(forKey: "selectedRowIndexPath")
            
            //MARK: - 민들레일 때
            if selectedPlantName == "민들레" {
                
                //물주기가 완료되었을 때만 물주기 모션 그래픽
                allocateWateringDataWhenBackgroundMode()
                growthInfo = UserDefaults.standard.integer(forKey: "selectedGrowthData")
                if cherishResultData[selectedRowIndexPath].isWatering == true {
                    plantImageView.isHidden = false
                    plantGifView.isHidden = false
                    plantGifView.alpha = 1.0
                    wateringGifPlay(.dandelionBg)
                    
                    // gif 물주기 모션뷰가 끝나고 나타날 뷰
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
                        
                        // gif뷰가 끝났다는 것은 물주기가 완료되었다는 뜻이므로 isWatering을 false로 바꿈!!
                        cherishResultData[selectedRowIndexPath].isWatering = false
                        
                        // 물주기 이후 5초가 지난 상태에서는 애니메이션이 끝나고 원래 식물 성장단계에 맞는 정적 이미지가 나와야함
                        // 하지만! 5초가 지나기 전에 다른 식물을 선택했어도 DispatchQueue로 인해 5초가 지나면 물주기를 했던 식물이 배경에 뜨게 되는 버그가 생김 (선택된 식물 != 배경에 나타나는 식물) --> 버그
                        // 따라서 선택된 식물을 다시 한 번 더 조회해서 할당해준 후 현재 클릭된 식물과 같은지 비교하는 과정을 거쳐 준다
                        selectedPlantName = UserDefaults.standard.string(forKey: "selectedPlantName")
                        
                        if selectedPlantName == "민들레" {
                            view.backgroundColor = .dandelionBg
                            // 식물3단계 파싱해주기
                            dandelionGrowth()
                            NotificationCenter.default.post(name: .postToReloadMainCell, object: nil)
                        }
                    }
                }
                // 시든상태
                else if cherishResultData[selectedRowIndexPath].dDay <= 0 {
                    
                    plantImageView.isHidden = false
                    plantGifView.isHidden = false
                    dandelionGrowth()
                    //                        self.plantGifView.image = UIImage.gif(name: "die_min_iOS")!
                    
                    self.view.backgroundColor = .diePlantGrey
                }
                //default
                else {
                    plantImageView.isHidden = false
                    // 식물3단계 파싱해주기
                    view.backgroundColor = .dandelionBg
                    dandelionGrowth()
                }
            }
            
            // MARK: - 아메리칸블루
            else if selectedPlantName == "아메리칸블루" {
                
                //물주기가 완료되었을 때만 물주기 모션 그래픽
                allocateWateringDataWhenBackgroundMode()
                growthInfo = UserDefaults.standard.integer(forKey: "selectedGrowthData")
                if cherishResultData[selectedRowIndexPath].isWatering == true {
                    plantImageView.isHidden = false
                    plantGifView.isHidden = false
                    plantGifView.alpha = 1.0
                    wateringGifPlay(.americanBlueBg)
                    
                    // gif 물주기 모션뷰가 끝나고 나타날 뷰
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
                        
                        cherishResultData[selectedRowIndexPath].isWatering = false
                        selectedPlantName = UserDefaults.standard.string(forKey: "selectedPlantName")
                        
                        if selectedPlantName == "아메리칸블루" {
                            plantImageView.isHidden = false
                            // 식물3단계 파싱해주기
                            americanBlueGrowth()
                            view.backgroundColor = .americanBlueBg
                            NotificationCenter.default.post(name: .postToReloadMainCell, object: nil)
                        }
                    }
                }
                // 시든상태
                else if cherishResultData[selectedRowIndexPath].dDay <= 0 {
                    
                    plantImageView.isHidden = false
                    plantGifView.isHidden = false
                    americanBlueGrowth()
                    //                        self.plantGifView.image = UIImage.gif(name: "die_min_iOS")!
                    
                    self.view.backgroundColor = .diePlantGrey
                }
                //default
                else {
                    plantImageView.isHidden = false
                    view.backgroundColor = .americanBlueBg
                    // 식물3단계 파싱해주기
                    americanBlueGrowth()
                }
            }
            
            // MARK: - 로즈마리
            else if selectedPlantName == "로즈마리" {
                
                //물주기가 완료되었을 때만 물주기 모션 그래픽
                allocateWateringDataWhenBackgroundMode()
                growthInfo = UserDefaults.standard.integer(forKey: "selectedGrowthData")
                if cherishResultData[selectedRowIndexPath].isWatering == true {
                    plantImageView.isHidden = false
                    plantGifView.isHidden = false
                    plantGifView.alpha = 1.0
                    wateringGifPlay(.rosemaryBg)
                    
                    // gif 물주기 모션뷰가 끝나고 나타날 뷰
                    DispatchQueue.main.asyncAfter(deadline: .now() +  5.0) { [self] in
                        
                        cherishResultData[selectedRowIndexPath].isWatering = false
                        selectedPlantName = UserDefaults.standard.string(forKey: "selectedPlantName")
                        
                        if selectedPlantName == "로즈마리" {
                            plantImageView.isHidden = false
                            // 식물3단계 파싱해주기
                            view.backgroundColor = .rosemaryBg
                            rosemaryGrowth()
                            NotificationCenter.default.post(name: .postToReloadMainCell, object: nil)
                        }
                    }
                }
                //물주기 미뤘을 때 시든상태
                else if cherishResultData[selectedRowIndexPath].dDay <= 0 {
                    
                    plantImageView.isHidden = false
                    plantGifView.isHidden = false
                    rosemaryGrowth()
                    //                        self.plantGifView.image = UIImage.gif(name: "die_min_iOS")!
                    
                    self.view.backgroundColor = .diePlantGrey
                }
                //default
                else {
                    plantImageView.isHidden = false
                    view.backgroundColor = .rosemaryBg
                    // 식물3단계 파싱해주기
                    rosemaryGrowth()
                }
            }
            
            // MARK: - 단모환
            else if selectedPlantName == "단모환" {
                
                //물주기가 완료되었을 때만 물주기 모션 그래픽
                allocateWateringDataWhenBackgroundMode()
                growthInfo = UserDefaults.standard.integer(forKey: "selectedGrowthData")
                if cherishResultData[selectedRowIndexPath].isWatering == true {
                    wateringGifPlay(.cactusBg)
                    plantImageView.isHidden = false
                    plantGifView.isHidden = false
                    plantGifView.alpha = 1.0
                    
                    // gif 물주기 모션뷰가 끝나고 나타날 뷰
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
                        
                        cherishResultData[selectedRowIndexPath].isWatering = false
                        selectedPlantName = UserDefaults.standard.string(forKey: "selectedPlantName")
                        
                        if selectedPlantName == "단모환" {
                            plantImageView.isHidden = false
                            plantImageViewTopConstraint.constant = 104
                            view.backgroundColor = .cactusBg
                            // 식물3단계 파싱해주기
                            sunGrowth()
                            NotificationCenter.default.post(name: .postToReloadMainCell, object: nil)
                            
                        }
                    }
                }
                //물주기 미뤘을 때 시든상태
                else if cherishResultData[selectedRowIndexPath].dDay <= 0 {
                    
                    plantImageView.isHidden = false
                    plantGifView.isHidden = false
                    sunGrowth()
                    //                        self.plantGifView.image = UIImage.gif(name: "die_min_iOS")!
                    
                    self.view.backgroundColor = .diePlantGrey
                }
                //default
                else {
                    plantImageView.isHidden = false
                    plantGifView.isHidden = false
                    plantImageViewTopConstraint.constant = 104
                    view.backgroundColor = .cactusBg
                    // 식물3단계 파싱해주기
                    sunGrowth()
                }
            }
            
            // MARK: - 스투키
            else {
                
                //물주기가 완료되었을 때만 물주기 모션 그래픽
                allocateWateringDataWhenBackgroundMode()
                growthInfo = UserDefaults.standard.integer(forKey: "selectedGrowthData")
                if cherishResultData[selectedRowIndexPath].isWatering == true {
                    plantImageView.isHidden = false
                    plantGifView.isHidden = false
                    plantGifView.alpha = 1.0
                    wateringGifPlay(.stuckyBg)
                    
                    // gif 물주기 모션뷰가 끝나고 나타날 뷰
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
                        
                        cherishResultData[selectedRowIndexPath].isWatering = false
                        selectedPlantName = UserDefaults.standard.string(forKey: "selectedPlantName")
                        
                        if selectedPlantName == "스투키" {
                            plantImageViewTopConstraint.constant = 104
                            plantImageView.isHidden = false
                            view.backgroundColor = .stuckyBg
                            // 식물3단계 파싱해주기
                            stuckyGrowth()
                            NotificationCenter.default.post(name: .postToReloadMainCell, object: nil)
                        }
                    }
                }
                //물주기 미뤘을 때 시든상태
                else if cherishResultData[selectedRowIndexPath].dDay <= 0 {
                    
                    plantImageView.isHidden = false
                    plantGifView.isHidden = false
                    stuckyGrowth()
                    //                        self.plantGifView.image = UIImage.gif(name: "die_min_iOS")!
                    
                    self.view.backgroundColor = .diePlantGrey
                    
                }
                //default
                else {
                    plantImageView.isHidden = false
                    plantImageViewTopConstraint.constant = 104
                    view.backgroundColor = .stuckyBg
                    // 식물3단계 파싱해주기
                    stuckyGrowth()
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
        LoadingHUD.hide()
    }
    
    //MARK: - kingfisher를 사용해서 물주기 모션 효과MA gif를 play
    func wateringGifPlay(_ backgroundColor: UIColor) {
        
        let filePath:String? = Bundle.main.path(forResource: "testwatering", ofType: "gif")
        let url = URL(fileURLWithPath: filePath!)
        self.view.backgroundColor = .diePlantGrey
        plantGifView.kf.setImage(
            with: url,
            placeholder: UIImage(),
            options: [
                .cacheOriginalImage,
            ])
        {
            result in
            switch result {
            case .success(_):
                self.view.backgroundColor = .diePlantGrey
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    UIView.transition(with: self.plantGifView, duration: 1, options: .curveEaseInOut, animations: { [self] in
                        plantGifView.alpha = 0
                        plantGifView.layoutIfNeeded()
                        
                    }, completion: { finished in
                        self.plantGifView.frame.origin.x = 10
                        self.plantGifView.frame.origin.y = 0
                    })
                }
                UIView.transition(with: self.view, duration: 2, options: .transitionCrossDissolve, animations: { [self] in
                    view.backgroundColor = backgroundColor
                    plantGifView.alpha = 1
                }, completion: nil)
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    
    //MARK: - 민들레 3단계 성장
    func dandelionGrowth() {
        
        if growthInfo < 25 {
            // 1단계
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 266, height: 0)
            let newHeight = CGFloat(336)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            plantImageViewLeading.constant = 64
            plantImageViewTrailing.constant = 2
            plantImageViewTopConstraint.constant = 298
            self.plantImageView.image = UIImage(named: "imgMin1")
            view.backgroundColor = .dandelionBg
        }
        else if growthInfo < 50 && growthInfo >= 25 {
            // 2단계
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 266, height: 0)
            let newHeight = CGFloat(439)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            plantImageViewLeading.constant = 65
            plantImageViewTrailing.constant = 2
            plantImageViewTopConstraint.constant = 210
            self.plantImageView.image = UIImage(named: "imgMin2")
            view.backgroundColor = .dandelionBg
        }
        else {
            // 3단계
//            plantImageView.isHidden = true
//            self.plantGifView.image = UIImage.gif(name: "real_min")!
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 272, height: 0)
            let newHeight = CGFloat(506)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            plantImageViewLeading.constant = 58
            plantImageViewTrailing.constant = 3
            plantImageViewTopConstraint.constant = 133
            self.plantImageView.image = UIImage(named: "mainImgMin")
            self.view.backgroundColor = .dandelionBg
        }
    }
    
    //MARK: - 아메리칸블루 3단계 성장
    func americanBlueGrowth() {
        if growthInfo < 25 {
            // 1단계
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 249, height: 0)
            let newHeight = CGFloat(368)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            plantImageViewLeading.constant = 82
            plantImageViewTrailing.constant = 2
            plantImageViewTopConstraint.constant = 278
            self.plantImageView.image = UIImage(named: "imgBlue1")
            view.backgroundColor = .americanBlueBg
        }
        else if growthInfo < 50 && growthInfo >= 25 {
            // 2단계
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 204, height: 0)
            let newHeight = CGFloat(461)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            plantImageViewLeading.constant = 107
            plantImageViewTrailing.constant = 22
            plantImageViewTopConstraint.constant = 145
            self.plantImageView.image = UIImage(named: "imgBlue2")
            view.backgroundColor = .americanBlueBg
        }
        else {
            // 3단계
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 199, height: 0)
            let newHeight = CGFloat(490)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            plantImageViewLeading.constant = 90
            plantImageViewTrailing.constant = 44
            plantImageViewTopConstraint.constant = 150
            self.plantImageView.image = UIImage(named: "mainImgAmericanblue")
            self.view.backgroundColor = .americanBlueBg
        }
    }
    
    //MARK: - 로즈마리 3단계 성장
    func rosemaryGrowth() {
        if growthInfo < 25 {
            // 1단계
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 222, height: 0)
            let newHeight = CGFloat(460)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            plantImageViewLeading.constant = 111
            plantImageViewTrailing.constant = 0
            plantImageViewTopConstraint.constant = 206
            self.plantImageView.image = UIImage(named: "imgRose1")
            view.backgroundColor = .rosemaryBg
        }
        else if growthInfo < 50 && growthInfo >= 25 {
            // 2단계
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 204, height: 0)
            let newHeight = CGFloat(572)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            plantImageViewLeading.constant = 107
            plantImageViewTrailing.constant = 0
            plantImageViewTopConstraint.constant = 106
            self.plantImageView.image = UIImage(named: "imgRose2")
            view.backgroundColor = .rosemaryBg
        }
        else {
            // 3단계
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 288, height: 0)
            let newHeight = CGFloat(521)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            plantImageViewLeading.constant = 45
            plantImageViewTrailing.constant = 0
            plantImageViewTopConstraint.constant = 104
            self.plantImageView.image = UIImage(named: "mainImgRosemary")
            view.backgroundColor = .rosemaryBg
        }
    }
    
    //MARK: - 단모환 3단계 성장
    func sunGrowth() {
        if growthInfo < 25 {
            // 1단계
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 275, height: 0)
            let newHeight = CGFloat(229)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            plantImageViewLeading.constant = 58
            plantImageViewTrailing.constant = 0
            plantImageViewTopConstraint.constant = 352
            self.plantImageView.image = UIImage(named: "imgSun1")
            view.backgroundColor = .cactusBg
        }
        else if growthInfo < 50 && growthInfo >= 25 {
            // 2단계
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 283, height: 0)
            let newHeight = CGFloat(350)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            plantImageViewLeading.constant = 50
            plantImageViewTrailing.constant = 0
            plantImageViewTopConstraint.constant = 235
            self.plantImageView.image = UIImage(named: "imgSun2")
            view.backgroundColor = .cactusBg
        }
        else {
            // 3단계
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 299, height: 0)
            let newHeight = CGFloat(457)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            plantImageViewLeading.constant = 26
            plantImageViewTrailing.constant = 8
            plantImageViewTopConstraint.constant = 215
            self.plantImageView.image = UIImage(named: "mainImgSun")
            self.view.backgroundColor = .cactusBg
        }
    }
    
    
    //MARK: - 스투키 3단계 성장
    func stuckyGrowth() {
        if growthInfo < 25 {
            // 1단계 323 287
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 323, height: 0)
            let newHeight = CGFloat(287)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            self.plantImageView.image = UIImage(named: "imgStuki1")
            plantImageViewTrailing.constant = 0
            plantImageViewLeading.constant = 10
            plantImageViewTopConstraint.constant = 322
            view.backgroundColor = .stuckyBg
        }
        else if growthInfo < 50 && growthInfo >= 25 {
            // 2단계
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 330, height: 0)
            let newHeight = CGFloat(345)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            self.plantImageView.image = UIImage(named: "imgStuki2")
            plantImageViewLeading.constant = 2
            plantImageViewTrailing.constant = 1
            plantImageViewTopConstraint.constant = 268
            view.backgroundColor = .stuckyBg
        }
        else {
            // 3단계
            plantGifView.isHidden = true
            plantImageView.frame.size = CGSize(width: 291, height: 0)
            let newHeight = CGFloat(466)
            plantImageViewHeight.constant = newHeight
            plantImageView.layoutIfNeeded()
            plantImageViewLeading.constant = 42
            plantImageViewTrailing.constant = 0
            plantImageViewTopConstraint.constant = 169
            self.plantImageView.image = UIImage(named: "mainImgStuki")
            self.view.backgroundColor = .stuckyBg
        }
    }
    
    
    //MARK: - 프로그레스바 커스텀
    func customProgressBarView(_ value : Int) {
        progressbarBackView.setBackColor(color: .white)
        progressbarView.setBackColor(color: .white)
        
        let greenGradient = CAGradientLayer()

        // frame을 잡아주고
        greenGradient.frame = progressbarView.bounds

        // 섞어줄 색을 colors에 넣어준 뒤
        greenGradient.colors = [UIColor.seaweed.cgColor,UIColor(red: 0, green: 171/255, blue: 162/255, alpha: 1.0).cgColor]
        
        greenGradient.startPoint = CGPoint(x: 0.5, y: 0)
        greenGradient.endPoint = CGPoint(x: 0.5, y: 1)
        
        let redGradient = CAGradientLayer()

        // frame을 잡아주고
        redGradient.frame = progressbarView.bounds

        // 섞어줄 색을 colors에 넣어준 뒤
        redGradient.colors = [UIColor.pinkSub.cgColor,UIColor(red: 248/255, green: 230/255, blue: 80/255, alpha: 1.0).cgColor]
        
        redGradient.startPoint = CGPoint(x: 0.5, y: 0)
        redGradient.endPoint = CGPoint(x: 0.5, y: 1)
        
        if value < 50 {
            progressbarView.setProgressColor(color: redGradient)
        }
        else {
            progressbarView.setProgressColor(color: greenGradient)
        }
        progressbarView.setProgressValue(currentValue: CGFloat(value))
    }
    
    //MARK: - 기기 사이즈에 맞춰 오토레이아웃 코드로 잡는 함수
    func setAutolayout() {
    
        if screenHeight == 896 {
            print("iPhone 11pro, 11proMax")
            blurBtnTopConstraint.constant = 530
            progressViewTopConstraint.constant = 140
            progressInnerViewTopConstraint.constant = 142
        }
        else if screenHeight == 926 {
            print("iPhone 12proMax")
            progressViewTopConstraint.constant = 150
            progressInnerViewTopConstraint.constant = 152
        }
        else if screenHeight == 844 {
            print("iPhone 12, 12pro")
            progressViewTopConstraint.constant = 127
            progressInnerViewTopConstraint.constant = 129
   
        }
        else if screenHeight == 736 {
            print("iPhone 8plus")
            progressViewTopConstraint.constant = 85
            progressInnerViewTopConstraint.constant = 87
        }
        else if screenHeight == 667 {
            print("iPhone 8")
            progressViewTopConstraint.constant = 20
            progressInnerViewTopConstraint.constant = 22
        }
        else {
            blurBtnTopConstraint.constant = 471
            progressViewTopConstraint.constant = 92
            progressInnerViewTopConstraint.constant = 94
        }
    }
    
    //MARK: - Alert View
    func noWateringDayAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    
    @objc func getPeopleData(_ notification: Notification) {
        cherishPeopleData = notification.object as! [ResultData]
        setMainResultData()
    }
    
    
    //MARK: - 메인의 친구 별 물주기, 시들기 상태를 저장할 수 있도록 cherishResultData에 데이터를 할당
    func setMainResultData() {
        
        cherishResultData.removeAll()
        for i in 0...cherishPeopleData.count - 1 {
            cherishResultData.append(MainPlantConditionData(id: cherishPeopleData[i].id, dDay: cherishPeopleData[i].dDay, isWatering: false, isWithered: false))
        }
    }
    
    //MARK: - 푸시알림 클릭 후 선택된 친구에 대한 물주기 팝업을 뜨게 하는 함수
    @objc func clickPushToMoveWateringPopup() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "PopUpWatering", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "PopUpWateringVC") as? PopUpWateringVC{
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: - 물주기 이후 물주기 모션을 주기 위해 선택된 식물의 인덱스값을 "물주기 상태"로 바꿔주는 함수
    @objc func isWateringReported(_ notification : Notification) {
        let selectedWateringFriendId = notification.object as! Int
        
        for i in 0...cherishResultData.count - 1 {
            
            if cherishResultData[i].id == selectedWateringFriendId {
                cherishResultData[i].isWatering = true
            }
        }
        setDataWithSelectedData()
    }
    
    
    //MARK: - 물주기&시들기를 위한 모델형 데이터인 cherishResultData에 아무런 값이 들어있지 않을 때, 임의로 값을 배졍하여 앱이 죽지 않도록 해주는 함수
    func allocateWateringDataWhenBackgroundMode() {
        if cherishResultData.count == 0 {
            let selectedRowIndexPath = UserDefaults.standard.integer(forKey: "selectedRowIndexPath")
            
            for _ in 0...selectedRowIndexPath {
                cherishResultData.append(MainPlantConditionData(id: 0, dDay: 1, isWatering: false, isWithered: false))
            }
        }
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
        if UserDefaults.standard.integer(forKey: "selecteddDayData") > 0 {
            // D-day가 아닐경우 미리 물주기 금지
            noWateringDayAlert(title: "아직 목이 마르지 않아요")
        }else if UserDefaults.standard.integer(forKey: "selecteddDayData") < 0{
            // D+day일 경우 미루기가 없는 물주기 팝업
            let storyBoard: UIStoryboard = UIStoryboard(name: "PopUpWatering", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "PopUpWatering_WithoutLaterVC") as? PopUpWatering_WithoutLaterVC{
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }else{
            // D-day일 경우 기본 물주기 팝업
            let storyBoard: UIStoryboard = UIStoryboard(name: "PopUpWatering", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "PopUpWateringVC") as? PopUpWateringVC{
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}


//MARK: - 로딩중 애니메이션
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
            popupView.frame = CGRect(x:0, y: 0, width: 80, height: 80)
            popupView.center = window.center
            popupView.layer.cornerRadius = popupView.layer.frame.height / 2
            backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.maxX, height: window.frame.maxY)
            // 윈도우의 크기에 맞춰 설정
            backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            popupView.backgroundColor = UIColor.white
            popupImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 65)
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
