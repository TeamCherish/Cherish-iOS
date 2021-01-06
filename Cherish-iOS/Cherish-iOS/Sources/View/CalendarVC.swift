//
//  CalendarVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/06.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController,SendViewControllerDelegate {
    
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
    @IBOutlet weak var calendarOrigin: FSCalendar!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var wholeCalendarHeight: NSLayoutConstraint!
    @IBOutlet weak var topAnchorHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomAnchorHeight: NSLayoutConstraint!
    @IBOutlet weak var toWaterLabel: UIStackView!
    @IBOutlet weak var wateredLabel: UIStackView!
    @IBOutlet weak var memoShowView: UIView!
    @IBOutlet weak var memoBtn: UIButton!
    
    let formatter = DateFormatter()
    let calendarCurrent = Calendar.current
    var memoBtnstatus: Bool? = true
    var calendarStatus: Bool?
    var expandSection = [Bool]()
    var items = [String]()
    var events = [Date]()
    var test_events = [Date]()
    var dateComponents = DateComponents()
    private var currentPage: Date?
    private lazy var today: Date = {
        return Date()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.expandSection = [Bool](repeating: false, count: self.items.count)
        calendarOrigin.delegate = self
        calendarOrigin.dataSource = self
        memoShowView.isHidden = true
        cal_Style()
        func forCalendarStatus(cal_status: Bool) {
            calendarStatus = cal_status
        }
    }

    
    @IBAction func moveToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func moveToUp(_ sender: Any) {
        if memoBtnstatus == true{
            memoBtnstatus = false
            memoBtn.setImage(UIImage(named: "icUpCalendar"), for: .normal)
            monthCalendar()
//            eventCategory.isHidden = true
        }else{
            memoBtnstatus = true
            memoBtn.setImage(UIImage(named: "icDownCalendar"), for: .normal)
            weekCalendar()
//            eventCategory.isHidden = false
        }
    }
 
    
    //MARK: -사용자 정의 함수
    func monthCalendar(){
        self.calendarOrigin?.setScope(.week, animated: true)
        UIView.animate(withDuration: 3.0, animations: {
            self.topAnchorHeight.constant = 0
            self.bottomAnchorHeight.constant = 0
            self.wateredLabel.isHidden = true
            self.toWaterLabel.isHidden = true
            self.wholeCalendarHeight?.constant = 150
//            self.wholeCalendarHeight?.constant = CGAffineTransform(scaleX: 1.0, y: 2.6)
        })
    }
    func weekCalendar(){
        self.calendarOrigin?.setScope(.month, animated: true)
        UIView.animate(withDuration: 3.0, animations: {
            self.topAnchorHeight.constant = 27
            self.bottomAnchorHeight.constant = 52
            self.wateredLabel.isHidden = false
            self.toWaterLabel.isHidden = false
            self.wholeCalendarHeight?.constant = 389
        })
    }
    
    func forCalendarStatus(cal_status: Bool) {
        calendarStatus = cal_status
    }
    
//    func defineCalStatus(){
//        // 달력버튼 클릭시 .month(true), 메모 클릭시 .week(false)
//        if calendarStatus ?? true {
//            monthCalendar()
//        }else{
//            weekCalendar()
//        }
//    }
    
    func cal_Style() {
        /// 캘린더 헤더 부분
        calendarOrigin.headerHeight = 50
        calendarOrigin.appearance.headerMinimumDissolvedAlpha = 0.0 /// 헤더 좌,우측 흐릿한 글씨 삭제
        calendarOrigin.locale = Locale(identifier: "ko_KR") /// 한국어로 변경
        calendarOrigin.appearance.headerDateFormat = "YYYY년 M월" /// 디폴트는 M월 YYYY년
        calendarOrigin.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
    
        /// 캘린터 텍스트 색
        calendarOrigin.backgroundColor = .white /// 배경색
        calendarOrigin.appearance.weekdayTextColor = .black///요일 색
        calendarOrigin.appearance.headerTitleColor = .black ///년도, 월 색
        calendarOrigin.appearance.selectionColor = UIColor.lightGray // 선택 된 날의 색
        calendarOrigin.appearance.todayColor = .darkGray // 오늘 색
        calendarOrigin.appearance.todaySelectionColor = .none // 오늘 선택 색
        
        // Month 폰트 설정
        calendarOrigin.appearance.headerTitleFont = UIFont(name: "NotoSansCJKKR-Regular", size: 16)
        
        // day 폰트 설정
        calendarOrigin.appearance.titleFont = UIFont(name: "Roboto-Regualr", size: 14)
        
        // 캘린더에 이번달 날짜만 표시하기 위함
//        calendarOrigin.placeholderType = .none
        
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

//MARK: -FSCalendar protocols
extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource{
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool){
        calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded ()
    }
    
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage?{
//        if calendarOrigin.date == "20201-01-11"{
//            return UIImage(named: "icUpCalendar")
//        }
//    }
    //이벤트 표시 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        if self.events.contains(date) {
            calendar.appearance.eventDefaultColor = .WateredRed // 물 준 날 색
            return 1
        }else if self.test_events.contains(date) {
            calendar.appearance.eventDefaultColor = .toWateringGreen // 물 주는 날 색
            return 1
        } else {
            return 0
        }
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
