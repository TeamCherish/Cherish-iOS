//
//  PlantEditVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/02/17.
//

import UIKit

class PlantEditVC: UIViewController {
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var periodTextField: UITextField!
    @IBOutlet weak var alarmTimeTextField: UITextField!
    @IBOutlet weak var alarmPicker: UIPickerView!
    @IBOutlet weak var editBtn: UIButton! {
        didSet {
            editBtn.backgroundColor = .seaweed
            editBtn.makeRounded(cornerRadius: 25.0)
        }
    }

    var parsedPeriod: String?
    var parsedAlarm: String?
    var birthPicker = UIPickerView()
    var periodPicker = UIPickerView()
    
    var num = [String](repeating: "0", count: 90)
    var month = [Int](repeating: 0, count: 12)
    var day = [Int](repeating: 0, count: 31)
    let period = ["day", "week", "month"]
    let time = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    let ampm = ["AM", "PM"]
    var cycle_date = 0
    var convertedAlarmTime: String?
    
    var checkPicker: Int = 0
    
    var textFieldEvent: Int = 0
    var popUpCheck: Int = 0
    var delegateCheck: Int = 0
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // 메인에서 온건지, 마페에서 온건지 구분 -> false, true
    var myCherishIsSelected = false
    // 정보 받아올 체리쉬 아이디 -> 메인에서 온거면 selectedFriendIdData 넣기, 마페에서 온거면 selectedCherish 넣기
    var selectedPlantId : Int?
    
    let formatter = DateFormatter()
    var serverBirth: String = ""
    
    var originPeriod: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCherishIsSelected = UserDefaults.standard.bool(forKey: "plantIsSelected")
        print("불값 ",myCherishIsSelected)
        if myCherishIsSelected == true {
            self.selectedPlantId = UserDefaults.standard.integer(forKey: "selectedCherish")
            UserDefaults.standard.set(false, forKey: "plantIsSelected")
            print("마페에서 온 아이디 ",selectedPlantId)
        }
        else {
            self.selectedPlantId = UserDefaults.standard.integer(forKey: "selectedFriendIdData")
            print("메인에서 온 아이디 ", selectedPlantId)
        }
        editBtn.isEnabled = true
        phoneTextField.isEnabled = false
//        birthTextField.isEnabled = false
        alarmTimeTextField.isEnabled = false
        setTextFieldBackgrouond()
        setTextFieldPadding()
        getPlantDataToEdit()
        createPicker()
//        setBirthPickerData()
        for i in 0...89 {
            num[i] = String(i+1)
        }
        for i in 0...11 {
            month[i] = i+1
        }
        for i in 0...30 {
            day[i] = i+1
        }
        nicknameTextField.delegate = self
        birthPicker.delegate = self
        birthPicker.dataSource = self
        periodPicker.delegate = self
        periodPicker.dataSource = self
        alarmPicker.delegate = self
        alarmPicker.dataSource = self
        nicknameTextField.delegate = self
        
        birthTextField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        periodTextField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
    }
    
    func setTextFieldBackgrouond() {
        nicknameTextField.background = UIImage(named: "box_add_plant_detail")
        nicknameTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        nicknameTextField.layer.borderWidth = 0
        
        birthTextField.background = UIImage(named: "box_add_plant_detail")
        birthTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        birthTextField.layer.borderWidth = 0
        birthTextField.tintColor = UIColor.clear
        
        phoneTextField.background = UIImage(named: "box_add_plant_detail")
        phoneTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        phoneTextField.layer.borderWidth = 0
        phoneTextField.isEnabled = false
        
        periodTextField.background = UIImage(named: "box_add_plant_detail")
        periodTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        periodTextField.layer.borderWidth = 0
        periodTextField.tintColor = UIColor.clear
        
        alarmTimeTextField.background = UIImage(named: "box_add_plant_detail")
        alarmTimeTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        alarmTimeTextField.layer.borderWidth = 0
        alarmTimeTextField.tintColor = UIColor.clear
    }
    
    func setTextFieldPadding() {
        nicknameTextField.addDetailRightPadding()
        birthTextField.addDetailRightPadding()
        phoneTextField.addDetailRightPadding()
        periodTextField.addDetailRightPadding()
        alarmTimeTextField.addDetailRightPadding()
    }
        
    // MARK: - cherishId로 등록해둔 식물 정보 받아오기
    func getPlantDataToEdit() {
        GetPlantDataService.shared.getPlantData(cherishId: self.selectedPlantId!) {(networkResult) -> (Void) in
            print("체리시아이디")
            print(self.selectedPlantId)
            switch networkResult {
            case .success(let data):
                if let plantData = data as? GetPlantData {
                    
                    self.parsedPeriod = "Every "+String(plantData.cherishDetail.cycleDate)+" day"
                    self.cycle_date = plantData.cherishDetail.cycleDate
        
                    // 알람시간 파싱
                    var noticeTimeHr = 0
                    var noticeTime = plantData.cherishDetail.noticeTime
                    let noticeTimeArr = noticeTime.components(separatedBy: ":")
                    noticeTimeHr = Int(noticeTimeArr[0])!
                    if noticeTimeHr <= 12 {
                        self.parsedAlarm = String(noticeTimeHr) + ":00 AM"
                    }
                    else {
                        self.parsedAlarm = String(noticeTimeHr-12) + ":00 PM"
                    }
                
                    self.nicknameTextField.text = plantData.cherishDetail.nickname
<<<<<<< HEAD
                    //MARK: - 생일 값이 Invalidate Date로 넘어올 때 처리
=======
                    
                    // 생일 등록 안하면 invalid 뜨는거 임시 수정
>>>>>>> cherishAddView
                    if plantData.cherishDetail.birth == "Invalid Date" {
                        self.birthTextField.text = "--.--"
                    }
                    else {
<<<<<<< HEAD
                        self.birthTextField.text = plantData.cherishDetail.birth
                    }
                    self.phoneTextField.text = plantData.cherishDetail.phone
=======
                        // 데이터 파싱해서 년도 빼기
                        self.formatter.dateFormat = "yyyy-MM-dd"
                        let date: Date = self.formatter.date(from: plantData.cherishDetail.birth)!
                        self.formatter.dateFormat = "MM월 dd일"
                        self.birthTextField.text = self.formatter.string(from: date)
                        self.serverBirth = plantData.cherishDetail.birth
                    }
                    
                    // 전화번호에 "-" 넣기
                    let phoneNumInt = Int(plantData.cherishDetail.phone)
                    let phoneNumArr = Array(String(plantData.cherishDetail.phone))
                    if phoneNumArr.count > 11 { // +8210 어쩌구
                        self.phoneTextField.text = plantData.cherishDetail.phone
                    }
                    else {
                        self.phoneTextField.text = "0" + phoneNumInt!.withHypen
                    }
//                    self.phoneTextField.text = plantData.cherishDetail.phone
                    
>>>>>>> cherishAddView
                    self.periodTextField.text = self.parsedPeriod
                    self.alarmTimeTextField.text = self.parsedAlarm
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
    
    // 생일 picker 미래로 설정 못하게
//    func setBirthPickerData() {
//        self.birthPicker.maximumDate = Date()
//    }
    
    // MARK: - 텍스트필드 안에 picker 넣기
    func createPicker() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        
        // bar button
        let doneBtnBirth = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedBirth))
        toolbar.setItems([doneBtnBirth], animated: true)
        
        let doneBtnPeriod = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePreseedPeriod))
        toolbar2.setItems([doneBtnPeriod], animated: true)
        
        // done 버튼 오른쪽으로
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([flexibleSpace, doneBtnBirth], animated: true)
        toolbar2.setItems([flexibleSpace, doneBtnPeriod], animated: true)
        
        // assign toolbar
        birthTextField.inputAccessoryView = toolbar
        periodTextField.inputAccessoryView = toolbar2
        
        // assign picker to the textField
        birthTextField.inputView = birthPicker
        periodTextField.inputView = periodPicker
        
        // birthPicker mode
//        birthPicker.datePickerMode = .date
//        birthPicker.preferredDatePickerStyle = .wheels
    }
    
    @objc func donePressedBirth() {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//
//        birthTextField.text = formatter.string(from: birthPicker.date)
        self.view.endEditing(true)
        textFieldEvent += 1
    }
    
    @objc func donePreseedPeriod() {
        if checkPicker == 0 {
            self.periodTextField.text = "Every 1 day"
            self.cycle_date = 1
            self.view.endEditing(true)
            textFieldEvent += 1
        }
        self.view.endEditing(true)
        textFieldEvent += 1
    }
    
    
    // MARK: - 식물 상세페이지로 돌아가기
    @IBAction func popToDetail(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 식물 삭제
    @IBAction func deletePlant(_ sender: Any) {
        let alert = UIAlertController(title: "정말로 식물을 삭제하시겠어요?", message: "", preferredStyle: UIAlertController.Style.alert)

        let cancel = UIAlertAction(title: "취소", style: .default, handler : nil)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            
            DeletePlantService.shared.deletePlant(CherishId: self.selectedPlantId!) { [self](networkResult) -> (Void) in
                switch networkResult {
                case .success(_):
                    print("통신성공")
                    let realert = UIAlertController(title: "삭제 완료되었습니다", message: "", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                        
                        // 메인 뷰로 돌아가기
                        self.navigationController?.popToRootViewController(animated: true)
                        appDel.isCherishDeleted = true
                        UserDefaults.standard.set("", forKey: "selectedNickNameData")
                        UserDefaults.standard.set(0, forKey: "selectedGrowthData")
                        UserDefaults.standard.set(0, forKey: "selectedGrowthData")
                        UserDefaults.standard.set("", forKey: "selectedModifierData")

                    }
                    realert.addAction(okAction)
                    present(realert, animated: true, completion: nil)
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
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: false, completion: nil)
    }
    
    // MARK: - 수정 완료 버튼
    @IBAction func editPlant(_ sender: Any) {
        var birthText = ""
        if birthTextField.text == "--.--" {
            birthText = "0000.00.00"
        }
        else {
            birthText = serverBirth
        }
        
        let water_notice = true
        
        // 식물 알람 시간 수정 안했을 때 파싱
        if delegateCheck == 0 {
            // 텍필.텍스트 값을 배열에 넣고 띄어쓰기로 슬라이스
            var alarmTimeArr: [String] = []
            var alarmHrArr: [Character] = []
            var alarmHrInt: Int = 0
            alarmTimeArr = (alarmTimeTextField.text?.components(separatedBy: " "))!

            // if 두번째원소 == "AM"
                // convert웅앵 = 첫번째원소
            if alarmTimeArr[1] == "AM" {
                convertedAlarmTime = alarmTimeArr[0]
                print("수정 안하고 AM일 때")
                print(convertedAlarmTime)
            }
            // else (두번째원소 == "PM"
                // 첫번째 원소를 배열로 만든다.
                // 그 배열의 첫번째 원소를 정수로 타입캐스팅한다.
                // 그리고 그 정수에 12를 더하고 ": 00" 붙여서 converted에 저장
            else if alarmTimeArr[1] == "PM" {
                alarmHrArr = Array(alarmTimeArr[0])
                alarmHrInt = Int(String(alarmHrArr[0]))! + 12 // char to int 한번에 못한다리~
                convertedAlarmTime = String(alarmHrInt)+":00"
                print("수정하고 PM일 때")
                print(convertedAlarmTime)
            }
        }
        
        // Alert message
        let alertEdit = UIAlertController(title: "수정 완료되었습니다", message: "", preferredStyle: UIAlertController.Style.alert)
        let okActionEdit = UIAlertAction(title: "확인", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertEdit.addAction(okActionEdit)
        
        print("수정하려는 데이터")
        print("닉네임", nicknameTextField.text!)
        print("생일", birthText)
        print("물주는 주기", cycle_date)
        print("물주는 알림 시간", convertedAlarmTime)
        print("물주는 알림 On off", water_notice)
        print("체리시 피케이", selectedPlantId)

        
        // 수정 서버 통신
        EditPlantService.shared.editPlant(nickname: nicknameTextField.text! , birth: birthText, cycle_date: cycle_date, notice_time: self.convertedAlarmTime!, water_notice_: water_notice, id: selectedPlantId!) { [self] (networkResult) -> (Void) in
            print("여기도 보이나요?")
            switch networkResult {
            case .success(_):
                print("통신성공")
                self.present(alertEdit, animated: true, completion: nil) ///왜 여기는 self 필요한겨..
                appDel.isCherishEdited = true
                UserDefaults.standard.set("", forKey: "selectedNickNameData")
                UserDefaults.standard.set(0, forKey: "selectedGrowthData")
                UserDefaults.standard.set(0, forKey: "selectedGrowthData")
                UserDefaults.standard.set("", forKey: "selectedModifierData")
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
}

// 전화번호에 하이픈 넣기
extension Int {
    var withHypen: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = "-"
        numberFormatter.groupingSize = 4
        return numberFormatter.string(from: self as NSNumber) ?? ""
    }
}

//MARK: - PickerView DataSource, Delegate
extension PlantEditVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == birthPicker {
            return 2
        }
        else if pickerView == periodPicker {
            return 3
        }
        else if pickerView == alarmPicker {
            return 3
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == birthPicker {
            if component == 0 {
                return month.count
            }
            else {
                return day.count
            }
        }
        else if pickerView == periodPicker {
            if component == 0 {
                return 1
            }
            else if component == 1 {
                return num.count
            }
            return 1
        }
        else if pickerView == self.alarmPicker {
            if component == 0 {
                return 12
            }
            else if component == 1 {
                return 1
            }
            else {
                return 2
            }
        }
        return 0
    }
}

extension PlantEditVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == birthPicker {
            if component == 0 {
                return String(month[row])+"월"
            }
            else {
                return String(day[row])+"일"
            }
        }
        else if pickerView == periodPicker {
            if component == 0 {
                return "Every"
            }
            else if component == 1 {
                return num[row]
            }
            return "day"
        }
        else if pickerView == alarmPicker {
            if component == 0 {
                return time[row]
            }
            else if component == 1 {
                return "00"
            }
            return ampm[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == birthPicker {
            let selectedMonth = pickerView.selectedRow(inComponent: 0)
            let selectedDay = pickerView.selectedRow(inComponent: 1)
            let fullBirthDate = String(month[selectedMonth])+"월 "+String(day[selectedDay])+"일"
            self.birthTextField.text = fullBirthDate
            self.serverBirth = "2000." + String(month[selectedMonth]) + "." + String(day[selectedDay])
            print(serverBirth)
        }
        else if pickerView == periodPicker {
            checkPicker = 1
            let selectedNum = pickerView.selectedRow(inComponent: 1)
//            let selectedPeriod = pickerView.selectedRow(inComponent: 2)
            let realNum = num[selectedNum]
            let fullData = "Every "+realNum+" day"
            self.cycle_date = Int(realNum)!
            self.periodTextField.text = fullData
        }
        else if pickerView == alarmPicker {
            delegateCheck = 1
            
            let selectedTime = pickerView.selectedRow(inComponent: 0)
            let selectedAMPM = pickerView.selectedRow(inComponent: 2)
            let realTime = time[selectedTime]
            let realAMPM = ampm[selectedAMPM]
            let fullAlarmTime = realTime+":00"+" "+realAMPM
            self.alarmTimeTextField.text = fullAlarmTime

            // 알람 시간 파싱
            var convertTime = 0
            switch realAMPM {
            case "AM":
                convertedAlarmTime = realTime+":00"
                print("수정하고 AM일 때")
                print(self.convertedAlarmTime)
            case "PM":
                convertTime = Int(realTime)! + 12
                var realConvertedTime = String(convertTime)
                convertedAlarmTime = realConvertedTime+":00"
                print("수정하고 PM일 때")
                print(self.convertedAlarmTime)
            default:
                convertTime = 0
            }
        }
    }
}

// MARK: - textfield delegate
extension PlantEditVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nicknameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case nicknameTextField:
            textFieldEvent += 1
            print(textFieldEvent)
        case birthTextField:
            textFieldEvent += 1
            print(textFieldEvent)
        case phoneTextField:
            textFieldEvent += 1
            print(textFieldEvent)
        case periodTextField:
            textFieldEvent += 1
            print(textFieldEvent)
            if popUpCheck == 0 {
                popUpCheck += 1
                let plantAlert = UIAlertController(title: "물주기 알림주기가 크게 변동되면\n배정된 식물이 변경될 수 있어요!", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                plantAlert.addAction(okAction)
                present(plantAlert, animated: true, completion: nil)
            }
        case alarmTimeTextField:
            textFieldEvent += 1
            print(textFieldEvent)
        default:
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nicknameTextField.endEditing(true)
        self.birthTextField.endEditing(true)
        self.phoneTextField.endEditing(true)
        self.periodPicker.endEditing(true)
        self.alarmTimeTextField.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let nicknameText = nicknameTextField.text else { return true }
        let limitLength = 8
        let newLength = nicknameText.count + string.count - range.length
                return newLength <= limitLength
    }
}
