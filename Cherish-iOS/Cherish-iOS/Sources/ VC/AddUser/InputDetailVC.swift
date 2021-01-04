//
//  InputDetailVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/03.
//

import UIKit

class InputDetailVC: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var alarmPeriodTextField: UITextField!
    @IBOutlet weak var alarmTimeTextField: UITextField!
    @IBOutlet weak var stateSwitch: UISwitch!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var alarmTimePicker: UIDatePicker!
    
    let datePicker = UIDatePicker()
    var periodPicker = UIPickerView()
    
    let num = ["1", "2", "3"]
    let period = ["day", "week", "month"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldBackgroundImage()
        createPicker()
        textFieldPadding()
        periodPicker.delegate = self
        periodPicker.dataSource = self
    }
    
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
    
    func textFieldPadding() {
        nameTextField.addDetailRightPadding()
        nicknameTextField.addDetailRightPadding()
        birthTextField.addDetailRightPadding()
        phoneTextField.addDetailRightPadding()
        alarmPeriodTextField.addDetailRightPadding()
        alarmTimeTextField.addDetailRightPadding()
    }
    
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
    }
    
    @objc func donePreseedPeriod() {
        self.view.endEditing(true)
    }
    
    @objc func changed() {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .none
        dateformatter.timeStyle = .short
        let date = dateformatter.string(from: alarmTimePicker.date)
        alarmTimeTextField.text = date
    }
}

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
        
        let fullData = "every "+realNum+" "+realPeriod
        self.alarmPeriodTextField.text = fullData
    }
}
