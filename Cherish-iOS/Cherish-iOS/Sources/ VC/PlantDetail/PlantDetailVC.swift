//
//  PlantDetailVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/03.
//

import UIKit


/// 캘린더의 상태가 무엇을 클릭하는지에 따라 달라지기 때문에 선언해놓습니다.
protocol SendViewControllerDelegate {
    func forCalendarStatus(cal_status: Bool)
}

class PlantDetailVC: UIViewController {

    @IBOutlet var plantCircularProgressView: CircularProgressView!
    @IBOutlet var backDropImageView: UIImageView!
    @IBOutlet var plantDetailBtn: UIButton!
    @IBOutlet var plantHealthStatusLabel: CustomLabel!
    @IBOutlet var heathStatusLabel: UILabel!
    @IBOutlet var memoTitleLabel: CustomLabel!
    @IBOutlet var keywordCV: UICollectionView!
    @IBOutlet var firstMemoView: UIView!
    @IBOutlet var secondMemoVIew: UIView!
    @IBOutlet var memoCardImageView: UIImageView!
    @IBOutlet var wateringBtn: UIButton!
    @IBOutlet var circularProgressViewTopConstant: NSLayoutConstraint!
    @IBOutlet var plantDetailBtnTopConstant: NSLayoutConstraint!
    @IBOutlet var memoCardHeight: NSLayoutConstraint!
    @IBOutlet var memoTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var memoTextFieldHeight: NSLayoutConstraint!
    @IBOutlet var keywordCVTopConstraint: NSLayoutConstraint!
    @IBOutlet var keywordCVBottomConstraint: NSLayoutConstraint!
    
    var isClicked:Bool = false
    var keywordArray:[KeywordData] = []
    var delegate: SendViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = CalendarVC()
        setControllers()
        makeCircularView()
        defineFirstPlantCardBtnStatus()
        makeDelegates()
        setKeywordData()
        makeCornerRadiusView()
        setAutoLayoutByScreenSize()
        
    }
    
    
    //MARK: - NC,TC 속성 정의함수
    func setControllers() {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func makeDelegates(){
        keywordCV.delegate = self
        keywordCV.dataSource = self
    }
    
    //MARK: - 원형 progressBar 생성함수
    func makeCircularView() {
        plantCircularProgressView.trackColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        plantCircularProgressView.progressColor = .seaweed
        plantCircularProgressView.setProgressWithAnimation(duration: 1.0, value: 0.5)
        
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
            print("iPhone 12 mini")
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
    
    func setKeywordData(){
        keywordArray.append(contentsOf: [
            KeywordData(keyword: "생일"),
            KeywordData(keyword: "취업준비중"),
            KeywordData(keyword: "헤어짐")
        ])
    }
    
    @IBAction func popUpPlantDetailExplainView(_ sender: UIButton) {
        
        if let vc = storyboard!.instantiateViewController(withIdentifier: "PlantDetailPopUpExplainVC") as? PlantDetailPopUpExplainVC {
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - 메인뷰로 돌아가는 함수
    @IBAction func popToCherishMainVC(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func moveToCalendar(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC {
            self.navigationController?.pushViewController(vc, animated: true)
            delegate?.forCalendarStatus(cal_status: true)
        }
        
    }
}
extension PlantDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywordArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let keywordCell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordCVCell", for: indexPath) as! KeywordCVCell
        
        keywordCell.keywordLabel.text = keywordArray[indexPath.row].keyword
        
        keywordCell.layer.borderWidth = 1
        keywordCell.layer.borderColor = CGColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1.0)
        keywordCell.layer.cornerRadius = 15
        
        
        return keywordCell
    }
}
