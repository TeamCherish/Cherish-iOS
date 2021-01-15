//
//  CalendarVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/06.
//

import UIKit
import FSCalendar


class CalendarVC: UIViewController {
    var fetchCalendar : [FetchCalendar] = []
    var keyword : [CalendarKeyword] = []
    var review: [String] = []
    var wasWatering : Bool = false
    var n : Int = 0
    var memoToCalendarDate: String?
    var memoToCalendarDateTemp: Date?
    var memoToEditDate: String?
    var memoToEditDateTemp: Date?
    var keywordForCV : [String] = []
    let formatter = DateFormatter()
    let calendarCurrent = Calendar.current
    var memoBtnstatus: Bool? = true
    var calendarStatus: String?
    var items = [String]()
    var watering_Events = [Date]()
    var futurewatering_Events = [Date]()
    var dateComponents = DateComponents()
    private var currentPage: Date?
    private lazy var today: Date = {
        return Date()
    }()
    
    //MARK: -@IBOutlet
    @IBOutlet weak var wholeCalendarView: UIView!{
        didSet{
            wholeCalendarView.makeRounded(cornerRadius: 20.0)
        }
    }
    @IBOutlet weak var memoView: UIView!{
        didSet{
            memoView.makeRounded(cornerRadius: 20.0)
        }
    }
    @IBOutlet weak var calendarOrigin: FSCalendar!{
        didSet{
            calendarOrigin.delegate = self
            calendarOrigin.dataSource = self
        }
    }
    
    @IBOutlet weak var keywordCVTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var keywordCVBotAnchor: NSLayoutConstraint!
    @IBOutlet weak var memoBtnTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var memoViewBotAnchor: NSLayoutConstraint!
    @IBOutlet weak var categoryBotAnchor: NSLayoutConstraint!
    @IBOutlet weak var toWaterLabel: UIStackView!
    @IBOutlet weak var wateredLabel: UIStackView!
    @IBOutlet weak var memoShowView: UIView!
    @IBOutlet weak var memoDateLabel: UILabel!
    @IBOutlet weak var memoBtn: UIButton!
    @IBOutlet weak var calendarKeywordCollectionView: UICollectionView!{
        didSet{
            self.calendarKeywordCollectionView.register(CalendarKeywordCVCell.nib(), forCellWithReuseIdentifier: CalendarKeywordCVCell.identifier)
        }
    }
    @IBOutlet weak var memoShowViewHeight: NSLayoutConstraint!
    @IBOutlet weak var memoTextLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var memoTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoShowView.isHidden = true
        cal_Style()
        defineCalStatus()
        forsmallPhone()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCalendarData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        calendarOrigin.reloadData()
        
        if calendarStatus == "memo"{
            memoMode()
        }
    }
    
    @IBAction func moveToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 메모 하단부 버튼
    @IBAction func moveToUp(_ sender: Any) {
        
        if memoBtnstatus == true{
            memoBtnstatus = false
            memoBtn.setImage(UIImage(named: "icUpCalendar"), for: .normal)
            weekCalendar()
        }else{
            memoBtnstatus = true
            memoBtn.setImage(UIImage(named: "icDownCalendar"), for: .normal)
            monthCalendar()
        }
    }
    
    /// 메모 수정 버튼
    @IBAction func moveToEdit(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Review", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "ReviewEditVC") as? ReviewEditVC {
            vc.space = memoTextLabel.text
            vc.edit_keyword = keywordForCV
            vc.dateForServer = memoToCalendarDate
            formatter.dateFormat = "yyyy-MM-dd"
            memoToEditDateTemp = formatter.date(from: memoToCalendarDate!)
            formatter.dateFormat = "yyyy년 MM월 dd일"
            memoToEditDate = formatter.string(from: memoToEditDateTemp!)
            vc.edit_date = memoToEditDate
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /// 달력에 < > 버튼
    @IBAction func moveToNext(_ sender: Any) {
        self.moveCurrentPage(moveUp: true)
    }
    @IBAction func moveToPrev(_ sender: Any) {
        self.moveCurrentPage(moveUp: false)
    }
    
    
    //MARK: -사용자 정의 함수
    
    /// 달력 좌우 페이지 넘기는 버튼
    private func moveCurrentPage(moveUp: Bool) {
        dateComponents.month = moveUp ? 1 : -1
        self.currentPage = calendarCurrent.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendarOrigin.setCurrentPage(self.currentPage!, animated: true)
    }
    
    func defineCalStatus(){
        // 달력버튼 클릭시 .month(true), 메모 클릭시 .week(false)
        if calendarStatus == "calendar" {
            monthCalendar()
        }else{
            weekCalendar()
            memoBtnstatus = false
            memoBtn.setImage(UIImage(named: "icUpCalendar"), for: .normal)
        }
    }
    
    //MARK: -SE2를 위한 AutoLayout 변경
    func forsmallPhone(){
        if UIDevice.current.isiPhoneSE2{
            memoShowView.removeConstraint(memoShowViewHeight)
            memoShowView.heightAnchor.constraint(greaterThanOrEqualToConstant: 190).isActive = true
            memoTextLabelHeight.constant = 33
            memoViewBotAnchor.constant = 52
        }
    }
    
    /// 주간 달력
    func monthCalendar(){
        self.calendarOrigin?.setScope(.month, animated: true)
        self.wateredLabel.isHidden = false
        self.toWaterLabel.isHidden = false
    }
    
    /// 월간 달력
    func weekCalendar(){
        self.calendarOrigin?.setScope(.week, animated: true)
        self.wateredLabel.isHidden = true
        self.toWaterLabel.isHidden = true
    }
    
    /// 식물 상세보기 메모 버튼->캘린더 이동시 해당 메모가 작성된 날짜 및 메모를 불러오기
    func memoMode() {
        calendarOrigin.reloadData()
        //        print("메캘메캘메캘메캘"+"\(memoToCalendarDate ?? "2020-12-26")")
        calendarOrigin.select(formatter.date(from: memoToCalendarDate ?? "2020-12-26"), scrollToDate: true)
        for i in 0...(fetchCalendar.count - 1) {
            if memoToCalendarDate == fetchCalendar[i].waterDate{
                memoShowView.isHidden = false
                formatter.dateFormat = "yyyy-MM-dd"
                memoToCalendarDateTemp = formatter.date(from: fetchCalendar[i].waterDate)
                //                print("메캘메캘메캘메캘"+"\(memoToCalendarDateTemp)!")
                formatter.dateFormat = "yyyy년 MM월 dd일" /// 시각적으로 보일 때에는 년,월,일 포함하여 파싱
                memoDateLabel.text = formatter.string(from: memoToCalendarDateTemp!)
                memoTextLabel.text = fetchCalendar[i].review
                n = i
                calendarKeywordCollectionView.delegate = self
                calendarKeywordCollectionView.dataSource = self
            }
        }
    }
    
    /// 캘린더 스타일
    func cal_Style() {
        /// 캘린더 헤더 부분
        
        calendarOrigin.headerHeight = 66
        calendarOrigin.weekdayHeight = 41
        calendarOrigin.appearance.headerMinimumDissolvedAlpha = 0.0 /// 헤더 좌,우측 흐릿한 글씨 삭제
        calendarOrigin.locale = Locale(identifier: "ko_KR") /// 한국어로 변경
        calendarOrigin.appearance.headerDateFormat = "YYYY년 M월" /// 디폴트는 M월 YYYY년
        calendarOrigin.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        
        /// 캘린터 색상 관련
        calendarOrigin.backgroundColor = .white /// 배경색
        calendarOrigin.appearance.titleTodayColor = .seaweed/// Today 날짜에 Default 표시되는 특정색 없음
        calendarOrigin.appearance.todayColor = .clear // Today 날짜에 Default 표시되는 특정 동그라미 색 없음
        calendarOrigin.appearance.todaySelectionColor = .none  // Today 날짜를 선택하면 표시되는 동그라미 색 없음
        calendarOrigin.appearance.headerTitleColor = .black /// 2021년 1월(헤더) 색
        calendarOrigin.appearance.weekdayTextColor = .black /// 요일(월,화,수..) 색
        calendarOrigin.appearance.selectionColor = .calendarSelectCircleGrey // 선택 된 날의 색
        calendarOrigin.appearance.titleWeekendColor = .black /// 주말 날짜 색
        calendarOrigin.appearance.titleDefaultColor = .black /// 기본 날짜 색
        
        // Month 폰트 설정
        calendarOrigin.appearance.headerTitleFont = UIFont(name: "NotoSansCJKKR-Medium", size: 16)
        
        // day 폰트 설정
        calendarOrigin.appearance.titleFont = UIFont(name: "Roboto-Regular", size: 14)
        
    }
    
    /// 캘린더 서버 통신
    func getCalendarData() {
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy-MM-dd"
        UserDefaults.standard.integer(forKey: "selectedFriendsIdData")
        CalendarService.shared.calendarLoad(id: UserDefaults.standard.integer(forKey: "selectedFriendIdData"), completion: { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let calendarResult = data as? CalendarSeeData{
                    /// 물주기 한번도 안했을 때
                    if calendarResult.water.count == 0 {
                        wasWatering = false
                        futurewatering_Events.append(formatter.date(from: calendarResult.futureWaterDate)!)
                        //print(futurewatering_Events)
                    }else{
                        /// 물준 이력이 있을 때
                        wasWatering = true
                        for i in 0...calendarResult.water.count-1{
                            fetchCalendar.append(contentsOf: [
                                FetchCalendar(waterDate: calendarResult.water[i].waterDate, review: calendarResult.water[i].review, keyword1: calendarResult.water[i].keyword1, keyword2: calendarResult.water[i].keyword2, keyword3: calendarResult.water[i].keyword3)
                            ])
                            keyword.append(contentsOf: [
                                CalendarKeyword(keyword1: calendarResult.water[i].keyword1, keyword2: calendarResult.water[i].keyword2, keyword3: calendarResult.water[i].keyword3)
                            ])
                            watering_Events.append(formatter.date(from: calendarResult.water[i].waterDate)!)
                            //print(watering_Events)
                        }
                        futurewatering_Events.append(formatter.date(from: calendarResult.futureWaterDate)!)
                        //print(futurewatering_Events)
                    }
                }
                print(keyword)
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        })
    }
    
    /// 키워드, 리뷰의 입력 여부에 따른 메모 뷰 크기 조정
    func memoHeightMode(idx: Int){
        /// 키워드 미입력 시
        if keywordForCV.count == 0 {
            calendarKeywordCollectionView.isHidden = true
            keywordCVTopAnchor.constant = 0
        }else{
            calendarKeywordCollectionView.isHidden = false
            keywordCVTopAnchor.constant = 14
        }
        /// 메모 미입력 시
        if fetchCalendar[idx].review.count < 1 || fetchCalendar[idx].review == "" {
            keywordCVBotAnchor.constant = 0
            memoTextLabel.isHidden = true
        }else{
            keywordCVBotAnchor.constant = 10
            memoTextLabel.isHidden = false
        }
        
        /// 키워드,메모 미입력 시
        if (fetchCalendar[idx].review.count < 1 || fetchCalendar[idx].review == "") && keywordForCV.count == 0  {
            memoBtnTopAnchor.constant = 22
            memoBtn.isHidden = true
        }else{
            memoBtnTopAnchor.constant = 17
            memoBtn.isHidden = false
        }
    }
}

//MARK: -Delegate & DataSource
/// 1
extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    /// Event 표시 Dot 사이즈 조정
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let eventScaleFactor: CGFloat = 1.8
        cell.eventIndicator.transform = CGAffineTransform(scaleX: eventScaleFactor, y: eventScaleFactor)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 3)
    }
    
    /// Calendar 주간, 월간 원활한 크기 변화를 위해
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool){
        calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded ()
    }
    
    /// 이벤트 밑에 Dot 표시 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.watering_Events.contains(date){
            return 1
        }
        if self.futurewatering_Events.contains(date){
            return 1
        }
        
        return 0
    }
    
    /// 물 준 날, 물 주는 날 Default Event Dot 색상 분기처리 - FSCalendarDelegateAppearance
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]?{
        if self.watering_Events.contains(date){
            return [UIColor.toWateringGreen]
        }
        
        if self.futurewatering_Events.contains(date){
            return [UIColor.WateredRed]
        }
        
        return nil
    }
    
    /// 물 준 날, 물 주는 날 Selected Event Dot 색상 분기처리 - FSCalendarDelegateAppearance
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        if self.watering_Events.contains(date){
            return [UIColor.toWateringGreen]
        }
        
        if self.futurewatering_Events.contains(date){
            return [UIColor.WateredRed]
        }
        
        return nil
    }
    
    
    
    /// 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(from: date) + " 선택됨")
        /// 물 준 적이 있고, 이벤트가 있다면 표시
        if wasWatering {
            for i in 0...fetchCalendar.count-1 {
                if formatter.string(from: date) == fetchCalendar[i].waterDate {
                    memoShowView.isHidden = false
                    formatter.locale = Locale(identifier: "ko")
                    formatter.dateFormat = "yyyy년 MM월 dd일" /// 시각적으로 보일 때에는 년,월,일 포함하여 파싱
                    memoDateLabel.text = formatter.string(from: date)
                    memoTextLabel.text = fetchCalendar[i].review
                    n = i
                    calendarKeywordCollectionView.reloadData()
                    calendarKeywordCollectionView.delegate = self
                    calendarKeywordCollectionView.dataSource = self
                    break
                }else{
                    memoShowView.isHidden = true
                }
            }
        }else{
            memoShowView.isHidden = true
        }
    }
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        keywordForCV = []
        print(formatter.string(from: date) + " 해제됨")
    }
    
    ///2
    //extension CalendarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if wasWatering {
            if keyword[n].keyword1 != ""{
                keywordForCV.append(keyword[n].keyword1)
            }
            if keyword[n].keyword2 != ""{
                keywordForCV.append(keyword[n].keyword2)
            }
            if keyword[n].keyword3 != ""{
                keywordForCV.append(keyword[n].keyword3)
            }
            memoHeightMode(idx: n)
        }
        
        return keywordForCV.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarKeywordCVCell.identifier, for: indexPath) as? CalendarKeywordCVCell else{
            return UICollectionViewCell()
        }
        
        cell.calendarKeywordLabel.text = keywordForCV[indexPath.row]
        return cell
    }
    
    //MARK: - Cell간의 좌우간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    
    //MARK: - 마진
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

