//
//  SignUpGenderVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/16.
//

import UIKit

class SignUpGenderVC: UIViewController {
    
    @IBOutlet weak var genderTextField: UITextField!{
        didSet{
            genderTextField.makeRounded(cornerRadius: 8)
            genderTextField.backgroundColor = .inputGrey
            genderTextField.addLeftPadding()
            genderTextField.tintColor = UIColor.clear
        }
    }
    @IBOutlet weak var ageTextField: UITextField!{
        didSet{
            ageTextField.makeRounded(cornerRadius: 8)
            ageTextField.backgroundColor = .inputGrey
            ageTextField.addLeftPadding()
            ageTextField.tintColor = UIColor.clear
        }
    }
    @IBOutlet weak var nextBtn: UIButton!{
        didSet{
            nextBtn.makeRounded(cornerRadius: 25.0)
            nextBtn.backgroundColor = .inputGrey
        }
    }
    var genderPicker = UIPickerView()
    var genderPickerStatus : Bool = false
    var agePicker = UIPickerView()
    var agePickerStatus : Bool = false
    let gender = ["여성","남성"]
    let formatter = DateFormatter()
    var limit: String?
    var limit_year : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        createPicker()
        pickerSetting()
    }
    
    func blankAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func pickerSetting(){
        genderPicker.delegate = self
        genderPicker.dataSource = self
        agePicker.delegate = self
        agePicker.dataSource = self
        formatter.dateFormat = "yyyy"
        limit = formatter.string(from: Date())
        limit_year = Int(limit!)! - 1900
    }
    
    //MARK: - 생일, 알림주기 텍스트필드 안에 picker 넣기
    func createPicker() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePreseedPeriod))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([flexibleSpace,doneBtn], animated: true)
        
        // assign toolbar
        genderTextField.inputAccessoryView = toolbar
        ageTextField.inputAccessoryView = toolbar
        
        // assign picker to the textField
        genderTextField.inputView = genderPicker
        ageTextField.inputView = agePicker

    }
    
    @objc func donePreseedPeriod() {
        self.view.endEditing(true)
        if genderPickerStatus && agePickerStatus{
            nextBtn.backgroundColor = .seaweed
            nextBtn.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextAction(_ sender: Any) {
        if genderPickerStatus && agePickerStatus{
            if let vc = self.storyboard?.instantiateViewController(identifier: "SignUpNicknameVC") as? SignUpNicknameVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            blankAlert(title: "Cherish", message: "빈칸을 채워주세요!")
        }
    }
    
}

extension SignUpGenderVC: UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genderPicker {
            return 2
        }else if pickerView == agePicker {
            return limit_year!
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == genderPicker {
            return gender[row]
        }else if pickerView == agePicker {
            return "\(Int(limit!)!-row)"
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderPicker {
            genderTextField.text = gender[row]
            genderTextField.textColor = .black
            genderPickerStatus = true
        }else if pickerView == agePicker {
            ageTextField.text = "\(Int(limit!)!-row)"
            ageTextField.textColor = .black
            agePickerStatus = true
        }
    }
}

