//
//  InputDetailVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/03.
//

import UIKit

class InputDetailVC: UIViewController {
    
    //MARK: - IBOUtlet
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var alarmPeriodTextField: UITextField!
    @IBOutlet weak var alarmTimeTextField: UITextField!
    @IBOutlet weak var stateSwitch: UISwitch!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var completeLabel: CustomLabel!
    @IBOutlet weak var alarmTimePicker: UIDatePicker!
    
    
    //MARK: - 변수 지정
    
    var name: String?
    var phoneNumber: String?
    
    let datePicker = UIDatePicker()
    var periodPicker = UIPickerView()
    
    let num = ["1", "2", "3"]
    let period = ["day", "week", "month"]
    
    var receiveItem = ""
    
    var cycle_date = 0
    
    var givenName: String?
    var givenPhoneNumber: String?
    
    //MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completeBtn.isEnabled = false
        setSwitch()
        textFieldBackgroundImage()
        textFieldPadding()
        createPicker()
        periodPicker.delegate = self
        periodPicker.dataSource = self
    }
    
    
    //MARK: - IBAction
    
    @IBAction func switchAction(_ sender: Any) {
        if stateSwitch.isOn == true {
            print("알람 받음")
            alarmPeriodTextField.placeholder = "Every 1 week"
            alarmPeriodTextField.isEnabled = true
        }
        else {
            print("알람 받지 않음")
            alarmPeriodTextField.placeholder = ""
            alarmPeriodTextField.text = ""
            alarmPeriodTextField.isEnabled = false
        }
    }
    
    @IBAction func closeUpToSelectVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpComplete(_ sender: Any) {
        guard let nameText = nameTextField.text,
              let nicknameText = nicknameTextField.text,
              let birthText = birthTextField.text,
              let phonenumberText = phoneTextField.text,
              let periodText = alarmPeriodTextField.text,
              let timeText = alarmPeriodTextField.text else { return }
        let alarmState = stateSwitch.isOn

        AddUserService.shared.addUser(name: nameText, nickname: nicknameText, birth: birthText, phone: phonenumberText, cycle_date: cycle_date, notice_time: timeText, water_notice_: alarmState, UserId: 6){ (networkResult) -> (Void) in
            switch networkResult {
            case .success(_):
                print("성공")
            case .requestErr(_):
                print("필요한 내용이 모두 입력되지 않았습니다")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }

        if completeBtn.isEnabled == true {
            guard let loadingVC = self.storyboard?.instantiateViewController(identifier: "LoadingPopUpVC") else {
                return
            }
            guard let resultVC = self.storyboard?.instantiateViewController(identifier: "PlantResultVC") else {
                return
            }
            UIView.animate(withDuration: 1.0, animations: {
                self.present(loadingVC, animated: true, completion: nil)
            }) {finished in
                self.present(resultVC, animated: true, completion: nil)
            }
        }
    }
    
    
    //MARK: - 함수 모음
    
    func setLabel() {
        if let givenName = self.givenName,
           let givenPhoneNumber = self.givenPhoneNumber {
            self.nameTextField.text = givenName
            self.phoneTextField.text = givenPhoneNumber
        }
    
    }
    
    //MARK: - UISwitch Custom
    func setSwitch() {
        stateSwitch.tintColor = UIColor.seaweed
        stateSwitch.onTintColor = UIColor.seaweed
        stateSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.74)
    }
    
    //MARK: - 텍스트필드 값 다 채워지면 완료 버튼 enable
    func enableCompleteBtn() {
//        let nameEmpty = nameTextField.text?.isEmpty
        let nicknameEmpty = nicknameTextField.text?.isEmpty
        let birthEmpty = birthTextField.text?.isEmpty
//        let phoneEmpty = phoneTextField.text?.isEmpty
        let alarmPeriodEmpty = alarmPeriodTextField.text?.isEmpty
        let alarmTimeEmpty = alarmTimeTextField.text?.isEmpty
        
        switch stateSwitch.isOn {
        case true:
            if (nicknameEmpty==false) && (birthEmpty==false) && (alarmTimeEmpty==false) && (alarmPeriodEmpty==false){
                completeBtn.isEnabled = true
                self.completeLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
            }
        case false:
            if (nicknameEmpty==false) && (birthEmpty==false) && (alarmTimeEmpty==false) {
                completeBtn.isEnabled = true
                self.completeLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
            }
        }
    }
    
    //MARK: - 텍스트필드 back ground image 지정
    func textFieldBackgroundImage() {
        nameTextField.background = UIImage(named: "box_half_add_plant_detail")
        nameTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        nameTextField.layer.borderWidth = 0
        
        nicknameTextField.background = UIImage(named: "box_half_add_plant_detail")
        nicknameTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        nicknameTextField.layer.borderWidth = 0
        
        birthTextField.background = UIImage(named: "box_add_plant_detail")
        birthTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        birthTextField.layer.borderWidth = 0
        
        phoneTextField.background = UIImage(named: "box_add_plant_detail")
        phoneTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        phoneTextField.layer.borderWidth = 0
        
        alarmPeriodTextField.background = UIImage(named: "box_add_plant_detail")
        alarmPeriodTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        alarmPeriodTextField.layer.borderWidth = 0
        
        alarmTimeTextField.background = UIImage(named: "box_add_plant_detail")
        alarmTimeTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        alarmTimeTextField.layer.borderWidth = 0
    }
    
    //MARK: - 텍스트필드 padding값 지정
    func textFieldPadding() {
        nameTextField.addDetailRightPadding()
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
        
        // alarm time
        alarmTimePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
        
        // assign toolbar
        birthTextField.inputAccessoryView = toolbar
        alarmPeriodTextField.inputAccessoryView = toolbar2
        
        // assign picker to the textField
        birthTextField.inputView = datePicker
        alarmPeriodTextField.inputView = periodPicker
        
        // datePicker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        alarmTimePicker.datePickerMode = .time
        alarmTimePicker.preferredDatePickerStyle = .wheels
        
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
        self.view.endEditing(true)
        enableCompleteBtn()
    }
    
    @objc func changed() {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .none
        dateformatter.timeStyle = .short
        let date = dateformatter.string(from: alarmTimePicker.date)
        alarmTimeTextField.text = date
        enableCompleteBtn()
    }
}

//MARK: - PickerView DataSource, Delegate
    ///pickerView 여러개에 대해 각각 datasource 수정ㅎ려면 어떡해야돼??
extension InputDetailVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 1
        }
        else {
            return 3
        }
    }
}

extension InputDetailVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "every"
        }
        else if component == 1 {
            return num[row]
        }
        return period[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedNum = pickerView.selectedRow(inComponent: 1)
        let selectedPeriod = pickerView.selectedRow(inComponent: 2)
        
        let realNum = num[selectedNum]
        let realPeriod = period[selectedPeriod]
        
        switch realPeriod {
        case "day":
            if realNum == "1" {self.cycle_date = 1}
            else if realNum == "2" {self.cycle_date = 2}
            else if realNum == "3" {self.cycle_date = 3}
        case "week":
            if realNum == "1" {self.cycle_date = 7}
            else if realNum == "2" {self.cycle_date = 14}
            else if realNum == "3" {self.cycle_date = 21}
        case "month":
            if realNum == "1" {self.cycle_date = 30}
            else if realNum == "2" {self.cycle_date = 60}
            else if realNum == "3" {self.cycle_date = 90}
        default:
            self.cycle_date = 0
        }
        
        let fullData = "every "+realNum+" "+realPeriod
        self.alarmPeriodTextField.text = fullData
    }
}
