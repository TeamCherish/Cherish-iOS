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
    @IBOutlet weak var laterCountingLabel: UILabel! ///(현재까지 미룬 횟수 n회)
    @IBOutlet weak var confirmBtn: UIButton!{
        didSet{
            confirmBtn.makeRounded(cornerRadius: 23.0)
            confirmBtn.backgroundColor = .btnGrey
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setWateringDate()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func completeLatering(_ sender: Any) {
        getLaterData()
        // 시드는 모션 뷰로 이동
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
        self.laterCountingLabel.text = UserDefaults.standard.string(forKey: "laterNumUntilNow")
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
                self.appDel.isWateringPostponed = true
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(date[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /// 1월-31 2월-28 3월-31일 4월-30일 5월-31일
        /// 6월-30일 7월-31일 8월-31일 9월-30일 10월-31
        /// 11월-30일 12월-31일
        /// 구분해줘야함
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
                
        changeDateDayLabel.text = "\(int_day! + date[row])"
        selectDateLabel.text = "\(date[row])"
        
        if int_month == 1 || int_month == 3 || int_month == 5 || int_month == 7 || int_month == 8 || int_month == 10 || int_month == 12 {
            if int_day! + date[row] > 31{
                changeDateMonthLabel.text = "\(int_month!+1)"
            }
        }else if int_month == 2{
            if int_day! + date[row] > 28{
                changeDateMonthLabel.text = "\(int_month!+1)"
            }
        }else{
            if int_day! + date[row] > 30{
                changeDateMonthLabel.text = "\(int_month!+1)"
            }
        }
        selectedDate = date[row]
    }
}
