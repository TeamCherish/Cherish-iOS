//
//  PlantDetailVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/03.
//

import UIKit

class PlantDetailVC: UIViewController {
    
    @IBOutlet var plantCircularProgressView: CircularProgressView!
    @IBOutlet var backDropImageView: UIImageView!
    @IBOutlet var plantDetailBtn: UIButton!
    @IBOutlet var plantNicknameLabel: CustomLabel!
    @IBOutlet var userNameInRoundViewLabel: CustomLabel!
    @IBOutlet var plantKindsInRoundViewLabel: CustomLabel!
    @IBOutlet var plantdDayLabel: CustomLabel!
    @IBOutlet var plantMaintainDayLabel: CustomLabel!
    @IBOutlet var plantBirthDayLabel: CustomLabel!
    @IBOutlet var plantHealthStatusLabel: CustomLabel!
    @IBOutlet var heathStatusLabel: UILabel!
    @IBOutlet var memoTitleLabel: CustomLabel!
    @IBOutlet var keywordCV: UICollectionView!
    @IBOutlet var firstMemoView: UIView!
    @IBOutlet var secondMemoVIew: UIView!
    @IBOutlet var firstMemoDayLabel: CustomLabel!
    @IBOutlet var secondMemoDayLabel: CustomLabel!
    @IBOutlet var firstMemoTextLabel: CustomLabel!
    @IBOutlet var secondMemoTextLabel: CustomLabel!
    @IBOutlet var firstMemoBtn: UIButton!
    @IBOutlet var secondMemoBtn: UIButton!
    @IBOutlet var memoCardImageView: UIImageView!
    @IBOutlet var wateringBtn: UIButton!
    @IBOutlet var circularProgressViewTopConstant: NSLayoutConstraint!
    @IBOutlet var plantDetailBtnTopConstant: NSLayoutConstraint!
    @IBOutlet var memoCardHeight: NSLayoutConstraint!
    @IBOutlet var memoTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var memoTextFieldHeight: NSLayoutConstraint!
    @IBOutlet var keywordCVTopConstraint: NSLayoutConstraint!
    @IBOutlet var keywordCVBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTagView: UIView!{
        didSet{
            nameTagView.makeRounded(cornerRadius: 13.0)
            nameTagView.backgroundColor = .clear
            nameTagView.layer.borderColor = UIColor.seaweed.cgColor
            nameTagView.layer.borderWidth  = 1.0
        }
    }
    
    var isClicked:Bool = false
    var plantId:Int = 0
    var reviewArray:[Review] = []
    var keywordArray:[String] = []
    var friendsPlantIdx:Int = UserDefaults.standard.integer(forKey: "selectedFriendIdData")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setControllers()
        defineFirstPlantCardBtnStatus()
        getPlantDetailData()
        makeDelegates()
        makeCornerRadiusView()
        setAutoLayoutByScreenSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LoadingHUD.show()
        friendsPlantIdx = UserDefaults.standard.integer(forKey: "selectedFriendIdData")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LoadingHUD.hide()
    }
    
    //MARK: - NC,TC 속성 정의함수
    func setControllers() {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func makeDelegates() {
        keywordCV.delegate = self
        keywordCV.dataSource = self
    }
    
    //MARK: - 식물상세뷰 데이터 받아오는 함수
    func getPlantDetailData() {
        PlantDetailService.shared.inquirePlantDetailView(friendsIdx: friendsPlantIdx) { [self]
            (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                print(data)
                if let plantDetailData = data as? PlantDetailData {
                    plantNicknameLabel.text = plantDetailData.nickname
                    userNameInRoundViewLabel.text = plantDetailData.name
                    plantKindsInRoundViewLabel.text = plantDetailData.plantName
                    
                    plantId = plantDetailData.plantId
                    
                    let url = URL(string: plantDetailData.plantThumbnailImageURL ?? "")
                    let imageData = try? Data(contentsOf: url!)
                    plantDetailBtn.setImage(UIImage(data: imageData!), for: .normal)
                    
                    plantdDayLabel.text = "D-\(plantDetailData.dDay)"
                    plantMaintainDayLabel.text = "\(plantDetailData.duration)일째"
                    plantBirthDayLabel.text = plantDetailData.birth
                    memoTitleLabel.text = "\(plantDetailData.nickname)와(과) 함께했던 이야기"
                    
                    keywordArray.append(plantDetailData.keyword1)
                    keywordArray.append(plantDetailData.keyword2)
                    keywordArray.append(plantDetailData.keyword3)
                    
                    // keywordArray 요소 중 null값을 필터링
                    keywordArray = keywordArray.filter(){$0 != ""}
                    if keywordArray.count == 0 {
                        keywordArray.append("키워드 없음")
                    }
                    plantHealthStatusLabel.text = plantDetailData.statusMessage
                    makeCircularView(Float(plantDetailData.gage))
                    
                    // 메모 데이터
                    reviewArray = plantDetailData.reviews
                    
                    /// 메모 데이터가 없을 때
                    if reviewArray.count == 0 {
                        // 캘린더로 이동할 수 있는 버튼을 숨기고, 누를 수 없게 한다
                        firstMemoBtn.isHidden = true
                        secondMemoBtn.isHidden = true
                        firstMemoBtn.isEnabled = false
                        secondMemoBtn.isEnabled = false
                        
                        firstMemoTextLabel.text = "메모를 입력하지 않았어요!"
                        secondMemoTextLabel.text = "메모를 입력하지 않았어요!"
                        
                        firstMemoDayLabel.text = "----"
                        secondMemoDayLabel.text = "----"
                    }
                    /// 메모 데이터가 하나일 때
                    else if reviewArray.count == 1 {
                        // 2020-01-01 -> 01/01로 파싱
                        let dateFormatter = DateFormatter()
                        let monthdateFormatter = DateFormatter()
                        let daydateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        let m = dateFormatter.date(from: reviewArray[0].waterDate)
                        let d = dateFormatter.date(from: reviewArray[0].waterDate)
                        
                        monthdateFormatter.dateFormat = "MM"
                        daydateFormatter.dateFormat = "dd"
                        
                        let month = monthdateFormatter.string(for: m)
                        let day = daydateFormatter.string(for: d)
                        
                        // 첫번째 메모데이터를 할당
                        firstMemoDayLabel.text = month! + "/" + day!
                        
                        //첫번째 메모데이터가 없을 때
                        if reviewArray[0].review == "" {
                            
                            firstMemoTextLabel.text = "메모를 입력하지 않았어요!"
                        }
                        //첫번째 메모데이터가 있을 때
                        else {
                            
                            firstMemoTextLabel.text = "\(reviewArray[0].review)"
                        }
                        
                        //메모데이터가 하나이니까 두번째 메모는 없다
                        secondMemoDayLabel.text = "----"
                        secondMemoTextLabel.text = "메모를 입력하지 않았어요!"
                        
                        // 캘린더로 이동할 수 있는 두번째 메모버튼을 숨기고, 누를 수 없게 한다
                        secondMemoBtn.isHidden = true
                        secondMemoBtn.isEnabled = false
                    }
                    /// 메모 데이터가 두개일 때
                    else {
                        // 2020-01-01 -> 01/01로 파싱
                        let dateFormatter = DateFormatter()
                        let monthdateFormatter = DateFormatter()
                        let daydateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        let m = dateFormatter.date(from: reviewArray[0].waterDate)
                        let d = dateFormatter.date(from: reviewArray[0].waterDate)
                        let sec_m = dateFormatter.date(from: reviewArray[1].waterDate)
                        let sec_d = dateFormatter.date(from: reviewArray[1].waterDate)
                        
                        monthdateFormatter.dateFormat = "MM"
                        daydateFormatter.dateFormat = "dd"
                        
                        let month = monthdateFormatter.string(for: m)
                        let day = daydateFormatter.string(for: d)
                        let sec_month = monthdateFormatter.string(for: sec_m)
                        let sec_day = daydateFormatter.string(for: sec_d)
                        
                        // 첫번째 메모 날짜 및 메모데이터를 할당
                        firstMemoDayLabel.text = month! + "/" + day!
                        if reviewArray[0].review == "" {
                            
                            firstMemoTextLabel.text = "메모를 입력하지 않았어요!"
                        }
                        else {
                            
                            firstMemoTextLabel.text = "\(reviewArray[0].review)"
                        }
                        // 두번째 메모 날짜 및 메모데이터를 할당
                        secondMemoDayLabel.text = sec_month! + "/" + sec_day!
                        if reviewArray[1].review == "" {
                            
                            secondMemoTextLabel.text = "메모를 입력하지 않았어요!"
                        }
                        else {
                            
                            secondMemoTextLabel.text = "\(reviewArray[1].review)"
                        }
                    }
                    keywordCV.reloadData()
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
    
    //MARK: - 원형 progressBar 생성함수
    func makeCircularView(_ value : Float ) {
        
        plantCircularProgressView.trackColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        
        
        if value <= 0.5 {
            plantCircularProgressView.progressColor = .pinkSub
        }
        else {
            plantCircularProgressView.progressColor = .seaweed
        }
        plantCircularProgressView.setProgressWithAnimation(duration: 1.0, value: value)
        
    }
    
    //MARK: - 식물카드의 첫 상태를 지정해주는 함수
    func defineFirstPlantCardBtnStatus() {
        backDropImageView.isHidden = true
        plantHealthStatusLabel.isHidden = true
        heathStatusLabel.isHidden = true
    }
    
    //MARK: - 뷰 CornerRadius 지정함수
    func makeCornerRadiusView() {
        firstMemoView.layer.cornerRadius = 15
        secondMemoVIew.layer.cornerRadius = 15
        wateringBtn.layer.cornerRadius = 25
    }
    
    //MARK: - 식물카드 클릭시 isClicked의 상태를 바꿔줘서 클릭 액션을 주는 함수
    @IBAction func plantDetailBtnClicked(_ sender: UIButton) {
        
        /// 클릭할 때마다 클릭의 속성값을 반대로 바꿔준다
        self.isClicked = !isClicked
        
        if isClicked == false {
            backDropImageView.isHidden = true
            plantHealthStatusLabel.isHidden = true
            heathStatusLabel.isHidden = true
        }
        else {
            backDropImageView.isHidden = false
            plantHealthStatusLabel.isHidden = false
            heathStatusLabel.isHidden = false
        }
    }
    
    //MARK: - 코드로 AutoLayout 맞추기
    func setAutoLayoutByScreenSize(){
        
        /// ScreenSize 가져오는 변수들
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        if screenWidth == 375 && screenHeight == 667 {
            backDropImageView.frame.size = CGSize(width: 100, height: 100)
            plantDetailBtn.frame.size = CGSize(width: 100, height: 100)
            plantCircularProgressView.frame.size = CGSize(width: 120, height: 120)
            
            //메모타이틀라벨의 Top Constraint를 10으로 설정
            memoTitleLabelTopConstraint.constant = 18
            
            keywordCVTopConstraint.constant = 3
            
            //메모카드이미지뷰 높이를 280으로 설정
            memoCardHeight.constant = 280
            
            //메모텍스트필드 높이를 45로 설정
            memoTextFieldHeight.constant = 45
            
            
            //물주기버튼의 radius값 Autolayout에 맞게 18로 설정
            wateringBtn.layer.cornerRadius = 23
        }
        
        /// iPhone12 mini size 보다 클 때
        else if screenWidth >= 375 && screenHeight >= 812 {
            backDropImageView.frame.size = CGSize(width: 140, height: 140)
            plantDetailBtn.frame.size = CGSize(width: 140, height: 140)
            plantCircularProgressView.frame.size = CGSize(width: 160, height: 160)
            
            //원형 프로그레스바의 Top Constraint를 50으로 설정
            circularProgressViewTopConstant.constant = 50
            
            //식물 상세보기 버튼의 Top Constraint를 60으로 설정
            plantDetailBtnTopConstant.constant = 60
            
            //메모카드이미지뷰 높이를 313으로 설정
            memoCardHeight.constant = 313
            
            keywordCVTopConstraint.constant = 2
            
            //메모텍스트필드 높이를 54로 설정
            memoTextFieldHeight.constant = 54
            
            //메모타이틀라벨의 Top Constraint를 25로 설정
            memoTitleLabelTopConstraint.constant = 25
        }
    }
    
    
    
    //MARK: - 첫번째 메모 연결버튼
    @IBAction func moveToFirstMemoDetail(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC {
            vc.calendarStatus = "memo"
            if reviewArray.count >= 1 {
                vc.memoToCalendarDate = reviewArray[0].waterDate
                print(reviewArray[0].waterDate)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK: - 두번째 메모 연결버튼
    @IBAction func moveToSecondMemoDetail(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC {
            vc.calendarStatus = "memo"
            if reviewArray.count >= 2 {
                vc.memoToCalendarDate = reviewArray[1].waterDate
                print("두번째 메모 연결버튼"+reviewArray[1].waterDate)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    //MARK: - 우측 상단 정보 뷰로 이동 팝업
    @IBAction func popUpPlantDetailExplainView(_ sender: UIButton) {
        
        if let vc = storyboard!.instantiateViewController(withIdentifier: "PlantDetailPopUpExplainVC") as? PlantDetailPopUpExplainVC {
            vc.plantId = plantId
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - 메인뷰로 돌아가는 함수
    @IBAction func popToCherishMainVC(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - 캘린더뷰로 이동하는 함수
    @IBAction func moveToCalendar(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC {
            vc.calendarStatus = "calendar"
            
            /// 달력 클릭 시 월간 모드
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func moveToWatering(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "PopUpWatering", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "PopUpWateringVC") as? PopUpWateringVC {
            vc.modalPresentationStyle = .overFullScreen ///탭바까지 Alpha값으로 덮으면서 팝업뷰
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
}

//MARK: - Extension : CollectionView
extension PlantDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywordArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let keywordCell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordCVCell", for: indexPath) as! KeywordCVCell
        
        if keywordArray.count != 0 {
            
            if keywordArray.count == 1 {
                keywordCell.keywordLabel.textColor = .pinkSub
                keywordCell.layer.borderColor = CGColor(red: 247/255, green: 89/255, blue: 108/255, alpha: 1.0)
            }
            else {
                keywordCell.keywordLabel.textColor = .black
                keywordCell.layer.borderColor = CGColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
            }
            keywordCell.keywordLabel.text = keywordArray[indexPath.row]
        }
        
        keywordCell.layer.borderWidth = 1
        keywordCell.layer.cornerRadius = 15
        
        
        return keywordCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if keywordArray.count == 1 {
            return CGSize(width: 44, height: 29)
        }
        return CGSize(width: 44, height: 29)
    }
}
