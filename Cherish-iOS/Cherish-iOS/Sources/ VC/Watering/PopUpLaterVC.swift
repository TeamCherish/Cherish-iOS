//
//  PopUpLaterVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/04.
//

import UIKit

class PopUpLaterVC: UIViewController {
    let date = [1,2,3,4,5,6,7] // 미루기 최대 7일
    var selectedDate : Int?
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: -@IBOutlet
    @IBOutlet weak var laterView: UIView!{
        didSet{
            laterView.dropShadow(color: .black, offSet: CGSize(width: 0, height: 4), opacity: 0.25, radius: 4)
            laterView.makeRounded(cornerRadius: 20.0)
        }
    }
    @IBOutlet weak var changeDateMonthLabel: UILabel!
    @IBOutlet weak var changeDateDayLabel: UILabel!
    @IBOutlet weak var selectDateLabel: UILabel!{
        didSet{
            selectDateLabel.backgroundColor = .inputGrey
            selectDateLabel.makeRounded(cornerRadius: 6)
        }
    }
    
    @IBOutlet weak var laterPickerView: UIPickerView!{
        didSet{
            laterPickerView.delegate = self
            laterPickerView.dataSource = self
        }
    }
//    @IBOutlet weak var laterCountingLabel: UILabel! ///(현재까지 미룬 횟수 n회)
    @IBOutlet weak var confirmBtn: UIButton!{
        didSet{
            confirmBtn.makeRounded(cornerRadius: 23.0)
            confirmBtn.backgroundColor = .btnGrey
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setWateringDate()
        setPickerDate()
    }
    
    

    /// 물 줄 날짜, 미룬 횟수 셋팅
    func setWateringDate(){
        guard let originDate = UserDefaults.standard.string(forKey: "wateringDate") else { return }
        
        let dateFormatter = DateFormatter()
        let monthdateFormatter = DateFormatter()
        let daydateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yy-MM-dd"
        
        let m = dateFormatter.date(from: originDate)
        let d = dateFormatter.date(from: originDate)
        
        monthdateFormatter.dateFormat = "MM"
        daydateFormatter.dateFormat = "dd"
        
        let month = monthdateFormatter.string(for: m)
        let day = daydateFormatter.string(for: d)
        
        let int_day = Int(day!)
        let int_month = Int(month!)
        
        self.changeDateMonthLabel.text = String(int_month!)
        self.changeDateDayLabel.text = String(int_day!+1) // 1일 미루었을 때의 날짜
        //self.laterCountingLabel.text = UserDefaults.standard.string(forKey: "laterNumUntilNow")
    }
    
    /// PickerView가 처음에 1이 선택된 상태고 그걸 future_water_date에 적용해놔야 하므로 didSelectRow 미리 호출
    func setPickerDate(){
        laterPickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView(laterPickerView, didSelectRow: 0, inComponent: 0)
    }
    
    // 윤년 계산 함수
    func leapYear(year: String) -> Bool{
        var leapYearStatus: Bool

        if (Int(year)! % 4) == 0 {
            if ((Int(year)! % 100) != 0){
                leapYearStatus = true
            }
            else{
                leapYearStatus = false
            }
        }
        else{
            leapYearStatus = false
        }
        
        return leapYearStatus
    }
    
    // Server-미루기
    func getLaterData(){
        print(UserDefaults.standard.integer(forKey: "selectedFriendIdData"))
        LaterService.shared.doLater(id: UserDefaults.standard.integer(forKey: "selectedFriendIdData"), postpone: selectedDate ?? 1, is_limit_postpone_number: UserDefaults.standard.bool(forKey: "noMinusisPossible")) { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let dataMessage = data as? String{
                    print(dataMessage)
                }

                self.dismiss(animated: true, completion: nil)
                self.appDel.isWateringPostponed = true
                
                // 미루기 횟수를 3회 초과했을 경우
                if UserDefaults.standard.bool(forKey: "noMinusisPossible") == true {
                    //시든모션 뜨도록 설정
                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "selectedFriendIdData"), forKey: "postponedIdData")
                }
                
                //메인뷰에 모달이 dismiss되었음을 알려주는 Noti
                NotificationCenter.default.post(name: .postPostponed, object: nil)
                

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
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func completeLatering(_ sender: Any) {
        getLaterData()
        // 시드는 모션 뷰로 이동
    }
    
    
}

//MARK: -Protocols
extension PopUpLaterVC: UIPickerViewDelegate, UIPickerViewDataSource{
    /// 하나의 PickerView 안에 몇 개의 선택 가능한 리스트를 표시할 것인지
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    /// PickerView에 표시될 항목의 개수를 반환하는 메서드
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return date.count
    }
    
    /// PickerView 각 선택 항목의 Title들을 정해주는 메서드
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(date[row])
    }
    
    /// PickerView의 didSelectRow
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let originDate = UserDefaults.standard.string(forKey: "wateringDate") else { return }
        
        // 년도, 월, 일로 쪼개기
        let dateFormatter = DateFormatter()
        let yeardateFormatter = DateFormatter()
        let monthdateFormatter = DateFormatter()
        let daydateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yy-MM-dd"
        
        let y = dateFormatter.date(from: originDate)
        let m = dateFormatter.date(from: originDate)
        let d = dateFormatter.date(from: originDate)
        
        yeardateFormatter.dateFormat = "yyyy"
        monthdateFormatter.dateFormat = "MM"
        daydateFormatter.dateFormat = "dd" /// 쪼개기 끝
        
        guard let year = yeardateFormatter.string(for: y) else { return } /// 연도
        let month = monthdateFormatter.string(for: m)
        let day = daydateFormatter.string(for: d)
        var int_day = Int(day!) /// 월
        let int_month = Int(month!) /// 일
        
        var leapYearStatus : Bool /// 윤년 계산을 위한 Bool값
        leapYearStatus = leapYear(year: year) /// 윤년 계산
        selectDateLabel.text = "\(date[row])" /// 팝업에 피커뷰에서 선택된 날짜 표시
        
        /// 31일까지 있는 달(1,3,5,7,8,10,12월)
        if int_month == 1 || int_month == 3 || int_month == 5 || int_month == 7 || int_month == 8 || int_month == 10 || int_month == 12 {
            if int_day! + date[row] > 31{
                changeDateMonthLabel.text = "\(int_month!+1)"
                int_day = int_day! == 31 ? 0 : -1 /// 이미 물주는 날짜가 말일이라면 0+data[row]
            }else{
                changeDateMonthLabel.text = "\(int_month!)"
                int_day = Int(day!)
            }
        /// 2월(윤년 계산)
        }else if int_month == 2{
            if leapYearStatus{
                if int_day! + date[row] > 29{
                    changeDateMonthLabel.text = "\(int_month!+1)"
                    int_day = int_day! == 29 ? 0 : -1
                }else{
                    changeDateMonthLabel.text = "\(int_month!)"
                    int_day = Int(day!)
                }
            }else{
                if int_day! + date[row] > 28{
                    changeDateMonthLabel.text = "\(int_month!+1)"
                    int_day = int_day! == 28 ? 0 : -1
                }else{
                    changeDateMonthLabel.text = "\(int_month!)"
                    int_day = Int(day!)
                }
            }
        /// 30일 까지 있는 달(4,6,9,11월)
        }else{
            if int_day! + date[row] > 30{
                changeDateMonthLabel.text = "\(int_month!+1)"
                int_day = int_day! == 30 ? 0 : -1
            }else{
                changeDateMonthLabel.text = "\(int_month!+1)"
                int_day = Int(day!)
            }
        }
        changeDateDayLabel.text = "\(int_day! + date[row])"
        selectedDate = date[row] /// 서버 통신을 위해 선택된 날짜 저장
    }
}
