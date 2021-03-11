//
//  InputDetailVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/03.
//

import UIKit

class InputDetailVC: UIViewController {
    
    //MARK: - IBOUtlet
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var alarmPeriodTextField: UITextField!
    @IBOutlet weak var alarmTimeTextField: UITextField!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var completeLabel: CustomLabel!
    @IBOutlet weak var alarmPicker: UIPickerView!
    
    
    //MARK: - 변수 지정
    
    let datePicker = UIDatePicker()
    var periodPicker = UIPickerView()
    
    let num = ["1", "2", "3"]
    let period = ["day", "week", "month"]
    let time = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    let ampm = ["AM", "PM"]
    
    var year: [Int] = []
    var month: [String] = []
    var day: [String] = []
    var receiveItem = ""
    var cycle_date = 0
    var givenName: String?
    var givenPhoneNumber: String?
    var convertedAlarmTime: String?
    
    var checkPicker: Int = 0
    
    //MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        print(givenName)
        print(givenPhoneNumber)
        super.viewDidLoad()
        setBirthPickerData()
        completeBtn.isEnabled = false
        setTextField()
        textFieldBackgroundImage()
        textFieldPadding()
        createPicker()
        nicknameTextField.delegate = self
        periodPicker.delegate = self
        periodPicker.dataSource = self
        alarmPicker.delegate = self
        alarmPicker.dataSource = self
        nicknameTextField.delegate = self
    }
    
    //MARK: - IBAction
    
    @IBAction func closeUpToSelectVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func touchUpComplete(_ sender: Any) {
        // nicknameTextField 비어있으면 nicknameText = givenName
        // birthTextField 비어있으면 birthText = "0000-00-00"
        var nicknameText = ""
        var birthText = ""
        
        // 식물애칭 관련 -> 테스트를 해보자! 식물 애칭 설정 안하고 넘어갔을 때 그냥 실명으로 잘 추가가 되는지~ -> 이름은 잘 넘어감
        if nicknameTextField.text?.isEmpty == true {
            nicknameText = givenName!
        }
        else {
            nicknameText = nicknameTextField.text!
        }
        
        // 생일 입력 관련 -> 생일도 테스트 해보자! 0000-00-00 으로 잘 넘어가는지~
        // -> 생일은 invalid date로 넘어감 -> 왜냐~~~~~~ 서버한테 물어보자
        if birthTextField.text?.isEmpty == true {
            birthText = "0000-00-00"
        }
        else {
            birthText = birthTextField.text!
        }
        
        guard let nameText = givenName,
              let phonenumberText = phoneTextField.text,
              let timeText = convertedAlarmTime,
              let periodText = alarmPeriodTextField.text else { return }
        
        print(nameText)
        print(nicknameText)
        print(birthText)
        print(phonenumberText)
        print(periodText)
        print(cycle_date)
        print(timeText)
    
        let alarmState = true
        
        if completeBtn.isEnabled == true {
            guard let loadingVC = self.storyboard?.instantiateViewController(identifier: "LoadingPopUpVC") as? LoadingPopUpVC else { return }
            guard let resultVC = self.storyboard?.instantiateViewController(identifier: "PlantResultVC") as? PlantResultVC else { return }
            
            AddUserService.shared.addUser(name: nameText, nickname: nicknameText, birth: birthText, phone: phonenumberText, cycle_date: cycle_date, notice_time: timeText, water_notice_: alarmState, UserId: UserDefaults.standard.integer(forKey: "userID")) {
                
                (networkResult) -> (Void) in
                print(UserDefaults.standard.integer(forKey: "userID"))
                switch networkResult {
                case .success(let data):
                    if let resultData = data as? AddUserData {
                        UserDefaults.standard.set(resultData.plant.id, forKey: "resultPlantId")
                        UserDefaults.standard.set(resultData.plant.modifier, forKey: "resultModifier")
                        UserDefaults.standard.set(resultData.plant.explanation , forKey: "resultExplanation")
                        UserDefaults.standard.set(resultData.plant.imageURL, forKey: "resultImgURL")
                        UserDefaults.standard.set(resultData.plant.flowerMeaning, forKey: "flowerMeaning")
                        print(resultVC.modifier)
                        //                        NotificationCenter.default.post(name: .sendPlantResult, object: nil)
                    }
                case .requestErr(_):
                    print("requesetErr")
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            }
            self.navigationController?.pushViewController(loadingVC, animated: false)
        }
    }
    
    
    //MARK: - 함수 모음
    
    func setTextField() {
        // 닉네임 자리 placeholder에 실명
        nicknameTextField.placeholder = givenName
        
        // 핸드폰 번호 자동으로 받아오기
        if let phoneNumber = self.givenPhoneNumber {
            self.phoneTextField.text = phoneNumber
        }
    }
    
    //MARK: - UISwitch Custom
//    func setSwitch() {
//        stateSwitch.tintColor = UIColor.seaweed
//        stateSwitch.onTintColor = UIColor.seaweed
//        stateSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.74)
//    }
    
    // 생일 picker 미래로 설정 못하게
    func setBirthPickerData() {
        self.datePicker.maximumDate = Date()
    }


    //MARK: - 필요한 값 다 채워지면 완료 버튼 enable
    func enableCompleteBtn() {
        let phoneEmpty = phoneTextField.text?.isEmpty
        let alarmPeriodEmpty = alarmPeriodTextField.text?.isEmpty
        let alarmTimeEmpty = alarmTimeTextField.text?.isEmpty
        
        if (phoneEmpty==false) &&
            (alarmTimeEmpty==false) &&
            (alarmPeriodEmpty==false){
            completeBtn.isEnabled = true
            self.completeLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        }
    }
    
    //MARK: - 텍스트필드 back ground image 지정
    func textFieldBackgroundImage() {
//        nameTextField.background = UIImage(named: "box_half_add_plant_detail")
//        nameTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
//        nameTextField.layer.borderWidth = 0
        
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
        
        alarmPeriodTextField.background = UIImage(named: "box_add_plant_detail")
        alarmPeriodTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        alarmPeriodTextField.layer.borderWidth = 0
        alarmPeriodTextField.tintColor = UIColor.clear // clear <-> clearColor
        
        alarmTimeTextField.background = UIImage(named: "box_add_plant_detail")
        alarmTimeTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        alarmTimeTextField.layer.borderWidth = 0
        
    }
    
    //MARK: - 텍스트필드 padding값 지정
    func textFieldPadding() {
        nicknameTextField.addDetailRightPadding()
        birthTextField.addDetailRightPadding()
        phoneTextField.addDetailRightPadding()
        alarmPeriodTextField.addDetailRightPadding()
        alarmTimeTextField.addDetailRightPadding()
    }
    
    //MARK: - 생일, 알림주기 텍스트필드 안에 picker 넣기
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
        
        // alarm time
//        alarmTimePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
        
//        alarmPikcer.addTarget(self, action: #selector(changed), for: .valueChanged)
        
        // assign toolbar
        birthTextField.inputAccessoryView = toolbar
        alarmPeriodTextField.inputAccessoryView = toolbar2
        
        // assign picker to the textField
        birthTextField.inputView = datePicker
        alarmPeriodTextField.inputView = periodPicker
        
        // datePicker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        
    }
    
    @objc func donePressedBirth() {
        //formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        birthTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        enableCompleteBtn()
    }
    
    @objc func donePreseedPeriod() {
        if checkPicker == 0 {
            print("쳌핔 0~")
            self.alarmPeriodTextField.text = "every 1 day"
            self.view.endEditing(true)
        }
        else {
            self.view.endEditing(true)
        }
        enableCompleteBtn()
    }
    
//    @objc func changed() {
//        let dateformatter = DateFormatter()
//        dateformatter.dateStyle = .none
//        dateformatter.timeStyle = .short
//        let date = dateformatter.string(from: alarmTimePicker.date)
//        alarmTimeTextField.text = date
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH"
//        enableCompleteBtn()
//    }
}

//MARK: - PickerView DataSource, Delegate
///pickerView 여러개에 대해 각각 datasource 수정ㅎ려면 어떡해야돼??
extension InputDetailVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == periodPicker {
            return 3
        }
        else if pickerView == alarmPicker {
            return 3
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == periodPicker {
            if component == 0 {
                return 1
            }
            else {
                return 3
            }
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

extension InputDetailVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == periodPicker {
            if component == 0 {
                return "every"
            }
            else if component == 1 {
                return num[row]
            }
            return period[row]
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
        if pickerView == periodPicker {
            checkPicker = 1
            print("체크피커")
            print(checkPicker)
            let selectedNum = pickerView.selectedRow(inComponent: 1)
            let selectedPeriod = pickerView.selectedRow(inComponent: 2)
            let realNum = num[selectedNum]
            let realPeriod = period[selectedPeriod]
            switch realPeriod {
            case "day":
                if realNum == "1" {
                    self.cycle_date = 1
                }
                else if realNum == "2" {
                    self.cycle_date = 2
                }
                else if realNum == "3" {
                    self.cycle_date = 3
                }
            case "week":
                if realNum == "1" {
                    self.cycle_date = 7
                }
                else if realNum == "2" {
                    self.cycle_date = 14
                }
                else if realNum == "3" {
                    self.cycle_date = 21
                }
            case "month":
                if realNum == "1" {
                    self.cycle_date = 30
                }
                else if realNum == "2" {
                    self.cycle_date = 60
                }
                else if realNum == "3" {
                    self.cycle_date = 90
                }
            default:
                self.cycle_date = 1
            }
            let fullData = "every "+realNum+" "+realPeriod
            self.alarmPeriodTextField.text = fullData
        }
        else if pickerView == alarmPicker {
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
            case "PM":
                convertTime = Int(realTime)! + 12
                var realConvertedTime = String(convertTime)
                convertedAlarmTime = realConvertedTime+":00"
            default:
                convertTime = 0
            }
            enableCompleteBtn()
        }
    }
}

// MARK: - textfield delegate
extension InputDetailVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nicknameTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nicknameTextField.endEditing(true)
        self.birthTextField.endEditing(true)
        self.phoneTextField.endEditing(true)
        self.alarmPeriodTextField.endEditing(true)
        self.alarmTimeTextField.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let nicknameText = nicknameTextField.text else { return true }
        let limitLength = 8
        let newLength = nicknameText.count + string.count - range.length
                return newLength <= limitLength
    }
}

