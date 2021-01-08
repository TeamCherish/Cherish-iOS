//
//  CalendarVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/06.
//

import UIKit
import FSCalendar

//protocol SendViewControllerDelegate {
//    func deliveryKeyword(memoText: String)
//}
class CalendarVC: UIViewController {
    let fake_keyword = ["생일","취업준비중","헤어짐"]
    var test_text = "오늘 남쿵이랑 연락을 했다. 바빠서 여자친구한테 소홀 해서 많이 싸우더만 이번엔 진짜 헤어진 것 같다.목소리가 너무 안좋아서 걱정됐는데 잘 챙겨줘야겠다."/// 85글자

    //    var delegate: SendViewControllerDelegate?
    let formatter = DateFormatter()
    let calendarCurrent = Calendar.current
    var memoBtnstatus: Bool? = true
    var calendarStatus: String?
    var items = [String]()
    var events = [Date]()
    var test_events = [Date]()
    var dateComponents = DateComponents()
    private var currentPage: Date?
    private lazy var today: Date = {
        return Date()
    }()
    
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
    
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var keywordCVHeight: NSLayoutConstraint!
    @IBOutlet weak var memoViewBotAnchor: NSLayoutConstraint!
    @IBOutlet weak var categoryBotAnchor: NSLayoutConstraint!
    @IBOutlet weak var toWaterLabel: UIStackView!
    @IBOutlet weak var wateredLabel: UIStackView!
    @IBOutlet weak var memoShowView: UIView!
    @IBOutlet weak var memoBtn: UIButton!
    @IBOutlet weak var calendarKeywordCollectionView: UICollectionView!{
        didSet{
            self.calendarKeywordCollectionView.register(CalendarKeywordCVCell.nib(), forCellWithReuseIdentifier: CalendarKeywordCVCell.identifier)
            calendarKeywordCollectionView.delegate = self
            calendarKeywordCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var memoShowViewHeight: NSLayoutConstraint!
    @IBOutlet weak var memoTextLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var memoTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.delegate = ReviewEditVC()
        memoShowView.isHidden = true
        memoTextLabel.text = test_text
        cal_Style()
        defineCalStatus()
        forsmallPhone()
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
            /// 확장 가능하게 우선순위 낮춤
//            memoTextLabelHeight.priority = .defaultLow
        }else{
            memoBtnstatus = true
            memoBtn.setImage(UIImage(named: "icDownCalendar"), for: .normal)
            monthCalendar()
        }
    }
    @IBAction func moveToEdit(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Review", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "ReviewEditVC") as? ReviewEditVC {
//            delegate?.deliveryKeyword(memoText: memoTextLabel.text ?? "")
            vc.space = memoTextLabel.text
            vc.edit_keyword = fake_keyword

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
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
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        let SHB = formatter.date(from: "2021-01-06")
        let love = formatter.date(from: "2021-01-26")
        let test1 = formatter.date(from: "2021-01-10")
        let test2 = formatter.date(from: "2021-01-15")
        events = [SHB!, love!]
        test_events = [test1!, test2!]
    }
}

//MARK: -Delegate & DataSource
/// 1
extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    /// Event 표시 Dot 사이즈 조정
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let eventScaleFactor: CGFloat = 1.5
        cell.eventIndicator.transform = CGAffineTransform(scaleX: eventScaleFactor, y: eventScaleFactor)
    }
    
    /// Calendar 주간, 월간 원활한 크기 변화를 위해
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool){
        calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded ()
    }
    
    /// 이벤트 밑에 Dot 표시 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.events.contains(date){
            return 1
        }
        if self.test_events.contains(date){
            return 1
        }
        
        return 0
    }
    
    /// 물 준 날, 물 주는 날 Default Event Dot 색상 분기처리 - FSCalendarDelegateAppearance
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]?{
        if self.events.contains(date){
            return [UIColor.toWateringGreen]
        }
        
        if self.test_events.contains(date){
            return [UIColor.WateredRed]
        }

        return nil
    }
    
    /// 물 준 날, 물 주는 날 Selected Event Dot 색상 분기처리 - FSCalendarDelegateAppearance
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        if self.events.contains(date){
            return [UIColor.toWateringGreen]
        }
        
        if self.test_events.contains(date){
            return [UIColor.WateredRed]
        }

        return nil
    }
    
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(formatter.string(from: date) + " 선택됨")
        if formatter.string(from: date) == "2021-01-06"{
            memoShowView.isHidden = false
        }else{
            memoShowView.isHidden = true
        }
    }
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(formatter.string(from: date) + " 해제됨")
    }
    
}

///2
extension CalendarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fake_keyword.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarKeywordCVCell.identifier, for: indexPath) as? CalendarKeywordCVCell else{
            return UICollectionViewCell()
        }
        cell.calendarKeywordLabel.text = fake_keyword[indexPath.row]
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
        return UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 19)
    }
}

