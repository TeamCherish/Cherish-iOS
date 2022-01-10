//
//  PopUpLaterVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/04.
//

import UIKit

class PopUpLaterVC: BaseController {
    private let date = [1,2,3,4,5,6,7] // 미루기 최대 7일
    private var selectedDate : Int?
    private var reciever: Int = 0
    private let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: -@IBOutlet
    @IBOutlet weak var laterView: UIView!
    @IBOutlet weak var changeDateMonthLabel: UILabel!
    @IBOutlet weak var changeDateDayLabel: UILabel!
    @IBOutlet weak var selectDateLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var laterPickerView: UIPickerView!{
        didSet{
            laterPickerView.delegate = self
            laterPickerView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blurGrey
        setStyle()
        setPickerDate()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func completeLatering(_ sender: Any) {
        /// 시드는 모션 뷰로 이동
        getLaterData()
    }
}

extension PopUpLaterVC {
    private func setStyle() {
        laterView.dropShadow(color: .cherishBlack, offSet: CGSize(width: 0, height: 4), opacity: 0.25, radius: 4)
        laterView.makeRounded(cornerRadius: 20.0)
        selectDateLabel.backgroundColor = .inputGrey
        selectDateLabel.makeRounded(cornerRadius: 6)
        confirmBtn.makeRounded(cornerRadius: 23.0)
        confirmBtn.backgroundColor = .btnGrey
    }
    
    // PickerView가 처음에 1이 선택된 상태고 그걸 future_water_date에 적용해놔야 하므로 didSelectRow 미리 호출
    private func setPickerDate(){
        laterPickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView(laterPickerView, didSelectRow: 0, inComponent: 0)
    }
    
    // 윤년 계산 함수
    private func leapYear(year: Int) -> Bool{
        return ( ((year % 4) == 0) && ((year % 100) != 0) ) ? true : false
    }
    
    private func showLaterDay(curDate: [Int], selectInt: Int) -> (year: Int, month: Int, day: Int) {
        let day_cal = (curDate[2]+selectInt)
        var final: (year: Int, month: Int, day: Int) = (0,0,0)
        
        // curDate[0]: year, curDate[1]: month, curDate[2]: day
        switch curDate[1] {
        case 1,3,5,7,8,10,12:
            if day_cal > 31 {
                final.month = (curDate[1] == 12) ? 1 : curDate[1]+1
                final.day = day_cal % 31
            } else {
                final.day = day_cal
            }
        case 2:
            if leapYear(year: curDate[0]) {
                if day_cal > 29 {
                    final.month = curDate[1]+1
                    final.day = day_cal % 29
                } else {
                    final.day = day_cal
                }
            }else{
                if day_cal > 28 {
                    final.month = curDate[1]+1
                    final.day = day_cal % 28
                } else {
                    final.day = day_cal
                }
            }
        default:
            if day_cal > 30 {
                final.month = curDate[1]+1
                final.day = day_cal % 30
            } else {
                final.day = day_cal
            }
        }
        return final
    }
    
    // Server-미루기
    private func getLaterData(){
        reciever = UserDefaults.standard.integer(forKey: "selectedFriendIdData")
        LaterService.shared.doLater(id: reciever, postpone: selectedDate ?? 1, is_limit_postpone_number: UserDefaults.standard.bool(forKey: "noMinusisPossible")) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let dataMessage = data as? String{
                    print(dataMessage)
                }
                self.dismiss(animated: true, completion: nil)
                self.appDel.isCherishPostponed = true
                /// 메인뷰에 모달이 dismiss되었음을 알려주는 Noti
                NotificationCenter.default.post(name: .postPostponed, object: reciever)
                
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

//MARK: -Protocols
extension PopUpLaterVC: UIPickerViewDelegate, UIPickerViewDataSource{
    // 하나의 PickerView 안에 몇 개의 선택 가능한 리스트를 표시할 것인지
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    // PickerView에 표시될 항목의 개수를 반환하는 메서드
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return date.count
    }
    
    // PickerView 각 선택 항목의 Title들을 정해주는 메서드
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(date[row])
    }
    
    // PickerView의 didSelectRow
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(date[row])
        guard let originDate = UserDefaults.standard.string(forKey: "wateringDate") else { return }
        
        /// 년도, 월, 일로 쪼개기
        let dateFormatter = DateFormatter().then {
            $0.dateFormat = "yyyy-MM-dd"
        }
        guard let date_origin = dateFormatter.date(from: originDate) else { return }
        let str_origin = dateFormatter.string(from: date_origin)
        let ymd = str_origin.split(separator: "-").map { Int(String($0))! }
        let final = showLaterDay(curDate: ymd, selectInt: date[row])
        
        changeDateMonthLabel.text = "\(final.month)"
        changeDateDayLabel.text = "\(final.day)"
        selectDateLabel.text = "\(date[row])"
        
        // 서버 통신을 위해 선택된 날짜 저장
        selectedDate = date[row]
    }
}
