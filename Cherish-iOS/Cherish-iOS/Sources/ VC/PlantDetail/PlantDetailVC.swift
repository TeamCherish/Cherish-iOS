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
    @IBOutlet var firstMemoBtnImg: UIImageView!
    @IBOutlet var secondMemoBtn: UIButton!
    @IBOutlet var secondMemoImg: UIImageView!
    @IBOutlet var memoCardImageView: UIImageView!
    @IBOutlet var wateringBtn: UIButton!
    @IBOutlet var circularProgressViewTopConstant: NSLayoutConstraint!
    @IBOutlet var plantDetailBtnTopConstant: NSLayoutConstraint!
    @IBOutlet var memoTextFieldHeight: NSLayoutConstraint!
    @IBOutlet var backdropImageViewHeight: NSLayoutConstraint!
    @IBOutlet var plantDetailBtnHeight: NSLayoutConstraint!
    @IBOutlet var circularViewHeight: NSLayoutConstraint!
    @IBOutlet var memoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var infoStackviewTopConstraint: NSLayoutConstraint!
    @IBOutlet var nicknameLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var nameTagViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var infoStackViewHeight: NSLayoutConstraint!
    @IBOutlet var keywordCVTopConstraint: NSLayoutConstraint!
    @IBOutlet var keywordCVBottomConstraint: NSLayoutConstraint!
    @IBOutlet var secondMemoTopConstraint: NSLayoutConstraint!
    @IBOutlet var nameTagViewHeight: NSLayoutConstraint!
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
    
    var myCherishIsSelected: Bool = false
    var myCherishIdx: Int = UserDefaults.standard.integer(forKey: "selectedCherish")
    
    
    /// ScreenSize 가져오는 변수들
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    // selectedCherish : 마이페이지에서 온 변수
    // selectedFriendIdData: 메인에서 온 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("뷰디드로드에서 출력해보삼", myCherishIdx)
        print("그냥 생짜로 출력?", UserDefaults.standard.integer(forKey: "selectedCherish"))
        setControllers()
        defineFirstPlantCardBtnStatus()
        
        myCherishIsSelected = UserDefaults.standard.bool(forKey: "plantIsSelected")
        
        if myCherishIsSelected == true {
            getPlantDataFromMyPage(cherishId: myCherishIdx)
        }
        else {
            getPlantDetailData()
        }
        makeDelegates()
        makeCornerRadiusView()
        setAutoLayoutByScreenSize()
        print("why...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LoadingHUD.show()
        setAutoLayoutByScreenSize()
        setControllers()
        friendsPlantIdx = UserDefaults.standard.integer(forKey: "selectedFriendIdData")
        if myCherishIsSelected == true {
            getPlantDataFromMyPage(cherishId: myCherishIdx)
        }
        else {
            getPlantDetailData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(popToMainView), name: .popToMainView, object: nil)
        print("why... viewwillappear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        LoadingHUD.hide()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .popToMainView, object: nil)
    }
    
    //MARK: - NC,TC 속성 정의함수
    func setControllers() {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.edgesForExtendedLayout = UIRectEdge.bottom
    }
    
    func makeDelegates() {
        keywordCV.delegate = self
        keywordCV.dataSource = self
    }
    
    @objc func popToMainView() {
        print("problem?")
        // 마이페이지에서 온건지 메인에서 온건지
        if UserDefaults.standard.bool(forKey: "plantIsSelected") == true{
            self.tabBarController?.selectedIndex = 0
            NotificationCenter.default.post(name: .mypageWatering, object: UserDefaults.standard.integer(forKey: "selectedCherish"))            
        }else{
            print("problem? popViewController")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getPlantDataFromMyPage(cherishId: Int) {
        PlantDetailService.shared.inquirePlantDetailView(friendsIdx: UserDefaults.standard.integer(forKey: "selectedCherish")) {
            [self](netwokResult) -> (Void) in
            switch netwokResult {
            case .success(let data):
                print(data)
                if let plantDetailDataFromMyPage = data as? PlantDetailData {
                    plantNicknameLabel.text = plantDetailDataFromMyPage.nickname
                    userNameInRoundViewLabel.text = plantDetailDataFromMyPage.name
                    plantKindsInRoundViewLabel.text = plantDetailDataFromMyPage.plantName
                    plantId = plantDetailDataFromMyPage.plantId
                    
                    let url = URL(string: plantDetailDataFromMyPage.plantThumbnailImageURL)
                    
                    let imageData = try? Data(contentsOf: url!)
                    plantDetailBtn.setImage(UIImage(data: imageData!), for: .normal)
                    
                    //MARK: - 선택된 친구 데이터의 dDay 값 파싱 -,+,0
                    if plantDetailDataFromMyPage.dDay == 0 {
                        plantdDayLabel.text = "D-day"
                    }
                    else if plantDetailDataFromMyPage.dDay < 0 {
                        plantdDayLabel.text = "D+\(-plantDetailDataFromMyPage.dDay)"
                    }
                    else {
                        plantdDayLabel.text = "D-\(plantDetailDataFromMyPage.dDay)"
                    }
                    
                    //MARK: - 생일 값이 Invalidate Date로 넘어올 때 처리
                    if plantDetailDataFromMyPage.birth == "Invalid Date" {
                        plantBirthDayLabel.text = "--.--"
                    }
                    else {
                        plantBirthDayLabel.text = plantDetailDataFromMyPage.birth
                    }
                    
                    plantMaintainDayLabel.text = "\(plantDetailDataFromMyPage.duration)일째"
                    
                    memoTitleLabel.text = "\(plantDetailDataFromMyPage.nickname)와(과) 함께했던 이야기"
                    print("지우기 전",keywordArray)
                    keywordArray.removeAll()
                    print("지운 후",keywordArray)
                    keywordArray.append(plantDetailDataFromMyPage.keyword1)
                    keywordArray.append(plantDetailDataFromMyPage.keyword2)
                    keywordArray.append(plantDetailDataFromMyPage.keyword3)
                    
                    // keywordArray 요소 중 null값을 필터링
                    keywordArray = keywordArray.filter(){$0 != ""}
                    if keywordArray.count == 0 {
                        keywordArray.append("등록된 키워드가 없어요")
                    }
                    
                    plantHealthStatusLabel.text = plantDetailDataFromMyPage.statusMessage
                    heathStatusLabel.text = plantDetailDataFromMyPage.status
                    makeCircularView(Float(plantDetailDataFromMyPage.gage))
                    
                    // 메모 데이터
                    reviewArray = plantDetailDataFromMyPage.reviews
                    
                    /// 메모 데이터가 없을 때
                    if reviewArray.count == 0 {
                        // 캘린더로 이동할 수 있는 버튼을 숨기고, 누를 수 없게 한다
                        firstMemoBtn.isHidden = true
                        firstMemoBtnImg.isHidden = true
                        secondMemoBtn.isHidden = true
                        secondMemoImg.isHidden = true
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
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    //MARK: - 식물상세뷰 데이터 받아오는 함수
    func getPlantDetailData() {
        PlantDetailService.shared.inquirePlantDetailView(friendsIdx: friendsPlantIdx) { [self]
            (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                print(data)
                if let plantDetailData = data as? PlantDetailData {
                    print("샌드위치 플랜트 아이디")
                    print(plantDetailData.plantId)
                    plantNicknameLabel.text = plantDetailData.nickname
                    userNameInRoundViewLabel.text = plantDetailData.name
                    plantKindsInRoundViewLabel.text = plantDetailData.plantName
                    
                    plantId = plantDetailData.plantId
                    
                    let url = URL(string: plantDetailData.plantThumbnailImageURL)
                    let imageData = try? Data(contentsOf: url!)
                    plantDetailBtn.setImage(UIImage(data: imageData!), for: .normal)
                    
                    //MARK: - 선택된 친구 데이터의 dDay 값 파싱 -,+,0
                    if plantDetailData.dDay == 0 {
                        plantdDayLabel.text = "D-day"
                    }
                    else if plantDetailData.dDay < 0 {
                        plantdDayLabel.text = "D+\(-plantDetailData.dDay)"
                    }
                    else {
                        plantdDayLabel.text = "D-\(plantDetailData.dDay)"
                    }
                    
                    plantMaintainDayLabel.text = "\(plantDetailData.duration)일째"
                    
                    print(plantDetailData.birth)
                    //MARK: - 생일 값이 Invalidate Date로 넘어올 때 처리
                    if plantDetailData.birth == "Invalid Date" {
                        plantBirthDayLabel.text = "--.--"
                    }
                    else {
                        plantBirthDayLabel.text = plantDetailData.birth
                    }
                    
                    memoTitleLabel.text = "\(plantDetailData.nickname)와(과) 함께했던 이야기"
                    
                    ///1) 첫 로드, 2) 키워드 수정 후 viewWillAppear에서만 로드되는 경우
                    
                    // 2)키워드 중복로드 방지를 위해 viewDidLoad에서 로드되었던 keywordArray를 지워준다
                    keywordArray.removeAll()
                    // 1)서버에서 받아온 keyword를 append한다
                    // 2)viewWillAppear에서 새롭게 띄워질 keyword를 append한다
                    keywordArray.append(plantDetailData.keyword1)
                    keywordArray.append(plantDetailData.keyword2)
                    keywordArray.append(plantDetailData.keyword3)
                    
                    // keywordArray 요소 중 null값을 필터링
                    keywordArray = keywordArray.filter(){$0 != ""}
                    if keywordArray.count == 0 {
                        keywordArray.append("등록된 키워드가 없어요")
                    }
                    plantHealthStatusLabel.text = plantDetailData.statusMessage
                    heathStatusLabel.text = plantDetailData.status
                    makeCircularView(Float(plantDetailData.gage))
                    
                    // 메모 데이터
                    reviewArray = plantDetailData.reviews
                    
                    /// 메모 데이터가 없을 때
                    if reviewArray.count == 0 {
                        // 캘린더로 이동할 수 있는 버튼을 숨기고, 누를 수 없게 한다
                        firstMemoBtn.isHidden = true
                        firstMemoBtnImg.isHidden = true
                        secondMemoBtn.isHidden = true
                        secondMemoImg.isHidden = true
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
                        secondMemoImg.isHidden = true
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
    
    //MARK: -Alert View
    func noWateringDayAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
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
            print("iPhone 8")
            
            infoStackViewHeight.constant = 43
            nameTagViewHeight.constant = 24
            plantNicknameLabel.font = UIFont(name: "Noto Sans CJK KR Bold", size: 18)
            heathStatusLabel.font = UIFont(name: "Noto Sans CJK KR Bold", size: 10)
            plantHealthStatusLabel.font = UIFont(name: "Noto Sans CJK KR Bold", size: 18)
            nicknameLabelTopConstraint.constant = 10
           
            
            //백드랍 뷰 사이즈 조정
            backDropImageView.frame.size = CGSize(width: 100, height: 0)
            let backdropNewHeight = CGFloat(100)
            backdropImageViewHeight.constant = backdropNewHeight
            backDropImageView.layoutIfNeeded()
            
            //식물 정보버튼 사이즈 조정
            plantDetailBtn.frame.size = CGSize(width: 100, height: 0)
            let plantDetailNewHeight = CGFloat(100)
            plantDetailBtnHeight.constant = plantDetailNewHeight
            plantDetailBtn.layoutIfNeeded()
            plantDetailBtnTopConstant.constant = 45
            print("plantDetailHeight",plantDetailBtn.frame.height)
            
            //원형 프로그레스바 사이즈 조정 (클래스에서 해줌. 여기서는 세부 constraint 조정)
            plantCircularProgressView.layoutIfNeeded()
            circularViewHeight.constant = 118
            circularProgressViewTopConstant.constant = 36
            
            
            memoTextFieldHeight.constant = 45
            memoViewTopConstraint.constant = 22
            infoStackviewTopConstraint.constant = 25
          
            
            //물주기버튼의 radius값 Autolayout에 맞게 18로 설정
            wateringBtn.layer.cornerRadius = 23
        }
        
        else if screenWidth == 428 && screenHeight == 926 {
            print("iPhone 12 Pro Max")
            
            plantNicknameLabel.font = UIFont(name: "Noto Sans CJK KR Bold", size: 23)
            heathStatusLabel.font = UIFont(name: "Noto Sans CJK KR Bold", size: 15)
            plantHealthStatusLabel.font = UIFont(name: "Noto Sans CJK KR Bold", size: 25)
            nicknameLabelTopConstraint.constant = 20
            nameTagViewTopConstraint.constant = 10
            infoStackViewHeight.constant = 50
            keywordCVTopConstraint.constant = 17
            keywordCVBottomConstraint.constant = 20
                
            //백드랍 뷰 사이즈 조정
            backDropImageView.frame.size = CGSize(width: 162, height: 0)
            let backdropNewHeight = CGFloat(162)
            backdropImageViewHeight.constant = backdropNewHeight
            backDropImageView.layoutIfNeeded()
            
            //식물 정보버튼 사이즈 조정
            plantDetailBtn.frame.size = CGSize(width: 162, height: 0)
            let plantDetailNewHeight = CGFloat(162)
            plantDetailBtnHeight.constant = plantDetailNewHeight
            plantDetailBtn.layoutIfNeeded()
            plantDetailBtnTopConstant.constant = 53
            print("plantDetailHeight",plantDetailBtn.frame.height)
            
            //원형 프로그레스바 사이즈 조정 (클래스에서 해줌. 여기서는 세부 constraint 조정)
            plantCircularProgressView.layoutIfNeeded()
            circularViewHeight.constant = 180
            circularProgressViewTopConstant.constant = 44
            
            
            infoStackviewTopConstraint.constant = 37
            memoTextFieldHeight.constant = 65
            memoViewTopConstraint.constant = 45
            secondMemoTopConstraint.constant = 15
            firstMemoView.layer.cornerRadius = 20
            secondMemoVIew.layer.cornerRadius = 20
            
          
            
            //물주기버튼의 radius값 Autolayout에 맞게 18로 설정
            wateringBtn.layer.cornerRadius = 23
        }
        
        else if screenWidth == 390 && screenHeight == 844 {
            print("iPhone 12, 12 Pro")
            
            plantNicknameLabel.font = UIFont(name: "Noto Sans CJK KR Bold", size: 21)
            nicknameLabelTopConstraint.constant = 13
            nameTagViewTopConstraint.constant = 6
            infoStackViewHeight.constant = 47
            keywordCVTopConstraint.constant = 10
            keywordCVBottomConstraint.constant = 16
            
            
            infoStackviewTopConstraint.constant = 37
            memoTextFieldHeight.constant = 56
            memoViewTopConstraint.constant = 34
            secondMemoTopConstraint.constant = 11
            firstMemoView.layer.cornerRadius = 16
            secondMemoVIew.layer.cornerRadius = 16
            
          
            //물주기버튼의 radius값 Autolayout에 맞게 18로 설정
            wateringBtn.layer.cornerRadius = 23
        }
        
        else if screenWidth == 414 && screenHeight == 896 {
            print("iPhone 11, 11 Pro Max")
            
            plantNicknameLabel.font = UIFont(name: "Noto Sans CJK KR Bold", size: 22)
            heathStatusLabel.font = UIFont(name: "Noto Sans CJK KR Bold", size: 14)
            plantHealthStatusLabel.font = UIFont(name: "Noto Sans CJK KR Bold", size: 24)
            nicknameLabelTopConstraint.constant = 20
            nameTagViewTopConstraint.constant = 10
            infoStackViewHeight.constant = 50
            keywordCVTopConstraint.constant = 17
            keywordCVBottomConstraint.constant = 20
                
            //백드랍 뷰 사이즈 조정
            backDropImageView.frame.size = CGSize(width: 150, height: 0)
            let backdropNewHeight = CGFloat(150)
            backdropImageViewHeight.constant = backdropNewHeight
            backDropImageView.layoutIfNeeded()
            
            //식물 정보버튼 사이즈 조정
            plantDetailBtn.frame.size = CGSize(width: 150, height: 0)
            let plantDetailNewHeight = CGFloat(150)
            plantDetailBtnHeight.constant = plantDetailNewHeight
            plantDetailBtn.layoutIfNeeded()
            plantDetailBtnTopConstant.constant = 53
            print("plantDetailHeight",plantDetailBtn.frame.height)
            
            //원형 프로그레스바 사이즈 조정 (클래스에서 해줌. 여기서는 세부 constraint 조정)
            plantCircularProgressView.layoutIfNeeded()
            circularViewHeight.constant = 168
            circularProgressViewTopConstant.constant = 44
            
            
            infoStackviewTopConstraint.constant = 37
            memoTextFieldHeight.constant = 60
            memoViewTopConstraint.constant = 45
            secondMemoTopConstraint.constant = 15
            firstMemoView.layer.cornerRadius = 20
            secondMemoVIew.layer.cornerRadius = 20
            
          
            //물주기버튼의 radius값 Autolayout에 맞게 18로 설정
            wateringBtn.layer.cornerRadius = 23
        }
        
        else if screenWidth == 414 && screenHeight == 736 {
            print("iPhone 8+")
            infoStackViewHeight.constant = 43
            nameTagViewHeight.constant = 24
            plantNicknameLabel.font = UIFont(name: "Noto Sans CJK KR Bold", size: 20)
            heathStatusLabel.font = UIFont(name: "Noto Sans CJK KR Bold", size: 11)
            plantHealthStatusLabel.font = UIFont(name: "Noto Sans CJK KR Bold", size: 20)
            nicknameLabelTopConstraint.constant = 13
           
            
            //백드랍 뷰 사이즈 조정
            backDropImageView.frame.size = CGSize(width: 130, height: 0)
            let backdropNewHeight = CGFloat(130)
            backdropImageViewHeight.constant = backdropNewHeight
            backDropImageView.layoutIfNeeded()
            
            //식물 정보버튼 사이즈 조정
            plantDetailBtn.frame.size = CGSize(width: 130, height: 0)
            let plantDetailNewHeight = CGFloat(130)
            plantDetailBtnHeight.constant = plantDetailNewHeight
            plantDetailBtn.layoutIfNeeded()
            plantDetailBtnTopConstant.constant = 45
            print("plantDetailHeight",plantDetailBtn.frame.height)
            
            //원형 프로그레스바 사이즈 조정 (클래스에서 해줌. 여기서는 세부 constraint 조정)
            plantCircularProgressView.layoutIfNeeded()
            circularViewHeight.constant = 148
            circularProgressViewTopConstant.constant = 36
            
            
            memoTextFieldHeight.constant = 55
            memoViewTopConstraint.constant = 35
            secondMemoTopConstraint.constant = 12
            infoStackviewTopConstraint.constant = 25
        }
        
        /// iPhone12 mini size 보다 클 때
        else {
            backDropImageView.frame.size = CGSize(width: 140, height: 140)
            plantDetailBtn.frame.size = CGSize(width: 140, height: 140)
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
        UserDefaults.standard.set(false, forKey: "plantIsSelected")
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
    
    //MARK: - 식물 수정뷰로 이동하는 함수
    @IBAction func moveToEdit(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "PlantDetail", bundle: nil)
        if let vc = storyBoard.instantiateViewController(identifier: "PlantEditVC") as? PlantEditVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - 물주기
    @IBAction func moveToWatering(_ sender: Any) {
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

//MARK: - Extension : CollectionView
extension PlantDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywordArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let keywordCell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordCVCell", for: indexPath) as! KeywordCVCell
        
        
        if keywordArray.count != 0 {
            
            if keywordArray[0] == "등록된 키워드가 없어요" {
                keywordCell.keywordLabel.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
                keywordCell.layer.borderColor = CGColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
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
