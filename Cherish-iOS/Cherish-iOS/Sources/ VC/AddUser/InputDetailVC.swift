//
//  InputDetailVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/03.
//

import UIKit

class InputDetailVC: UIViewController {
    
    //MARK: - IBOUtlet
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nicknameLabel: CustomLabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var alarmPeriodTextField: UITextField!
    @IBOutlet weak var alarmTimeTextField: UITextField!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var alarmPicker: UIPickerView!
    
    
    //MARK: - 변수 지정
    
    var birthPicker = UIPickerView()
    var periodPicker = UIPickerView()
    
    var num = [String](repeating: "1", count: 90)
    let period = ["day", "week", "month"]
    let time = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    let ampm = ["AM", "PM"]
    var month = [Int](repeating: 0, count: 12)
    var day = [Int](repeating: 0, count: 31)
    
    var receiveItem = ""
    var cycle_date = 0
    var givenName: String?
    var givenPhoneNumber: String?
    var convertedAlarmTime: String?
    
    var checkPicker: Int = 0
    
    var serverBirth: String = ""
    
    let screenHeight = UIScreen.main.bounds.size.height
        
    //MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setConstraints()
        completeBtn.isEnabled = false
        setTextField()
        textFieldBackgroundImage()
        textFieldPadding()
        createPicker()
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
    }
    
    //MARK: - IBAction
    
    @IBAction func closeUpToSelectVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func touchUpComplete(_ sender: UIButton) {
        // nicknameTextField 비어있으면 nicknameText = givenName
        // birthTextField 비어있으면 birthText = "0000-00-00"
        var nicknameText = ""
        var birthText = ""
        
        if nicknameTextField.text?.isEmpty == true {
            nicknameText = givenName!
        }
        else {
            nicknameText = nicknameTextField.text!
        }
    
        if birthTextField.text == "" {
            birthText = "0000.00.00"
        }
        else {
            birthText = serverBirth
        }
        guard let nameText = givenName,
              let phonenumberText = givenPhoneNumber,
              let timeText = convertedAlarmTime,
              let periodText = alarmPeriodTextField.text else { return }

        let alarmState = true
        
        if completeBtn.isEnabled == true {
            guard let loadingVC = self.storyboard?.instantiateViewController(identifier: "LoadingPopUpVC") as? LoadingPopUpVC else { return }
            loadingVC.modalPresentationStyle = .overCurrentContext
            
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
                        
                        self.present(loadingVC, animated: false, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.dismiss(animated: false) {
                                self.navigationController?.pushViewController(resultVC, animated: true)
                            }
                        }
                        self.navigationController?.pushViewController(resultVC, animated: true)
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
        }
    }
    
    //MARK: - 함수 모음
    
    func setConstraints() {
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        var constraintTop : NSLayoutConstraint
        if screenHeight <= 667 {
            // 아이폰 7,8 이하
            constraintTop = nicknameLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 11.0)
        }
        else {
            constraintTop = nicknameLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 26.0)
        }
        constraintTop.isActive = true
        nicknameLabel.widthAnchor.constraint(equalToConstant: 52).isActive = true
        nicknameLabel.heightAnchor.constraint(equalTo: nicknameLabel.widthAnchor, multiplier: 6.0/13.0).isActive = true
        nicknameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27).isActive = true
        nicknameLabel.bottomAnchor.constraint(equalTo: nicknameTextField.topAnchor, constant: -7).isActive = true
    }
    
    func setTextField() {
        // 닉네임 자리 placeholder에 실명
        nicknameTextField.placeholder = givenName
        
        // 핸드폰 번호 자동으로 받아오기
        if let phoneNumber = self.givenPhoneNumber {
            let phoneNumInt = Int(phoneNumber)
            let phoneNumArr = Array(phoneNumber)
            let phoneNumWithHypen = phoneNumInt?.withHypen ?? "00-0000-0000"
            if phoneNumArr.count > 11 {
                self.phoneTextField.text = phoneNumber
            }
            else {
                self.phoneTextField.text = "0" + phoneNumWithHypen
            }
        }
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
            self.completeBtn.setTitleColor(.white, for: .normal)
        }
    }
    
    //MARK: - 텍스트필드 back ground image 지정
    func textFieldBackgroundImage() {
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
                
        // assign toolbar
        birthTextField.inputAccessoryView = toolbar
        alarmPeriodTextField.inputAccessoryView = toolbar2
        
        // assign picker to the textField
        birthTextField.inputView = birthPicker
        alarmPeriodTextField.inputView = periodPicker
        
    }
    
    @objc func donePressedBirth() {
        self.view.endEditing(true)
        enableCompleteBtn()
    }
    
    @objc func donePreseedPeriod() {
        if checkPicker == 0 {
            self.alarmPeriodTextField.text = "Every 1 day"
            self.cycle_date = 1
            self.view.endEditing(true)
        }
        else {
            self.view.endEditing(true)
        }
        enableCompleteBtn()
    }
}

//MARK: - PickerView DataSource, Delegate

extension InputDetailVC: UIPickerViewDataSource {
    
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

extension InputDetailVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == birthPicker {
            if component == 0 {
                return String(month[row]) + "월"
            }
            else {
                return String(day[row]) + "일"
            }
        }
        
        else if pickerView == periodPicker {
            if component == 0 {
                return "Every"
            }
            else if component == 1 {
                return num[row]
            }
            else if component == 2 {
                return "day"
            }
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
            let fullBirthDate = String(month[selectedMonth]) + "월 " + String(day[selectedDay])+"일"
            self.birthTextField.text = fullBirthDate
            self.serverBirth = "2000." + String(month[selectedMonth]) + "." + String(day[selectedDay])
            print(serverBirth)
        }
        else if pickerView == periodPicker {
            checkPicker = 1
            let selectedNum = pickerView.selectedRow(inComponent: 1)
            let realNum = num[selectedNum]
            self.cycle_date = Int(num[selectedNum])!
            let fullData = "Every "+realNum+" day"
            self.alarmPeriodTextField.text = fullData
        }
        else if pickerView == alarmPicker {
            let selectedTime = pickerView.selectedRow(inComponent: 0)
            let selectedAMPM = pickerView.selectedRow(inComponent: 2)
            let realTime = time[selectedTime]
            let realAMPM = ampm[selectedAMPM]
            let fullAlarmTime = time[selectedTime]+":00"+" "+ampm[selectedAMPM]
            self.alarmTimeTextField.text = fullAlarmTime
            
            // 알람 시간 파싱
            switch realAMPM {
            case "AM":
                if realTime == "12" {
                    convertedAlarmTime = "24:00"
                }
                else {
                    convertedAlarmTime = realTime+":00"
                }
            case "PM":
                if realTime == "12" {
                    convertedAlarmTime = "12:00"
                }
                else {
                    convertedAlarmTime = String((Int(realTime)! + 12))+":00"
                }
            default:
                convertedAlarmTime = "0:00"
            }
            print("알람시간 \(convertedAlarmTime)")
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

