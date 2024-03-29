//
//  SignUpGenderVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/16.
//

//import UIKit
//
//class SignUpGenderVC: UIViewController, UIGestureRecognizerDelegate {
//    
//    //MARK: -변수 선언부
//    var genderPicker = UIPickerView()
//    var agePicker = UIPickerView()
//    var limit: String?
//    var limit_year : Int?
//    let gender = ["여성","남성"]
//    let formatter = DateFormatter()
//    var forSending = ["","",""]
//    
//    //MARK: -@IBOutlet
//    @IBOutlet weak var genderTextField: UITextField!{
//        didSet{
//            genderTextField.makeRounded(cornerRadius: 8)
//            genderTextField.backgroundColor = .inputGrey
//            genderTextField.addLeftPadding()
//            genderTextField.tintColor = UIColor.clear
//        }
//    }
//    @IBOutlet weak var ageTextField: UITextField!{
//        didSet{
//            ageTextField.makeRounded(cornerRadius: 8)
//            ageTextField.backgroundColor = .inputGrey
//            ageTextField.addLeftPadding()
//            ageTextField.tintColor = UIColor.clear
//        }
//    }
//    @IBOutlet weak var nextBtn: UIButton!{
//        didSet{
//            nextBtn.makeRounded(cornerRadius: 25.0)
//            nextBtn.backgroundColor = .seaweed
//            nextBtn.setTitleColor(.white, for: .normal)
//            
//        }
//    }
//    @IBOutlet weak var beforeImageView: UIImageView!
//    @IBOutlet weak var afterImageView: UIImageView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        print(forSending)
//        createPicker()
//        pickerSetting()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        UIView.animate(withDuration: 0.3, animations: {
//            self.beforeImageView.image = UIImage(named: "joinCircleUnselected")
//        },completion: {finished in
//            UIView.animate(withDuration: 0.5, animations: {
//                self.afterImageView.image = UIImage(named: "joinCircleSelected")
//            })
//        })
//    }
//    
//    //MARK: -사용자 정의 함수
//    //화면 터치시 키보드 내리기
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//    
//    func pickerSetting(){
//        genderPicker.delegate = self
//        genderPicker.dataSource = self
//        agePicker.delegate = self
//        agePicker.dataSource = self
//        formatter.dateFormat = "yyyy"
//        limit = formatter.string(from: Date())
//        limit_year = Int(limit!)! - 1900
//    }
//    
//    //MARK: - 생일, 알림주기 텍스트필드 안에 picker 넣기
//    func createPicker() {
//        // toolbar
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        // bar button
//        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePreseedPeriod))
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        toolbar.setItems([flexibleSpace,doneBtn], animated: true)
//        
//        // assign toolbar
//        genderTextField.inputAccessoryView = toolbar
//        ageTextField.inputAccessoryView = toolbar
//        
//        // assign picker to the textField
//        genderTextField.inputView = genderPicker
//        ageTextField.inputView = agePicker
//
//    }
//    
//    @objc func donePreseedPeriod() {
//        self.view.endEditing(true)
//        if genderTextField.text == ""{
//            genderTextField.attributedPlaceholder = NSAttributedString(string: "여성", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
//        }
//    }
//    
//    //MARK: -@IBAction
//    @IBAction func backAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    @IBAction func nextAction(_ sender: Any) {
//        if let vc = self.storyboard?.instantiateViewController(identifier: "SignUpNicknameVC") as? SignUpNicknameVC {
//            self.navigationController?.pushViewController(vc, animated: true)
//            vc.forSignUp[0] = forSending[0]
//            vc.forSignUp[1] = forSending[1]
//            vc.forSignUp[2] = forSending[2]
//            if genderTextField.text!.count == 0 {
//                vc.forSignUp[3] = "여성"
//            }else{
//                vc.forSignUp[3] = genderTextField.text!
//            }
//            if ageTextField.text!.count == 0 {
//                vc.forSignUp[4] = "2021"
//            }else{
//                vc.forSignUp[4] = ageTextField.text!
//            }
//        }
//    }
//    
//}
//
////MARK: -Protocols
//extension SignUpGenderVC: UIPickerViewDataSource,UIPickerViewDelegate{
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView == genderPicker {
//            return 2
//        }else if pickerView == agePicker {
//            return limit_year!
//        }
//        return 0
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        
//        if pickerView == genderPicker {
//            return gender[row]
//        }else if pickerView == agePicker {
//            return "\(Int(limit!)!-row)"
//        }
//        return ""
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView == genderPicker {
//            genderTextField.text = gender[row]
//        }else if pickerView == agePicker {
//            ageTextField.text = "\(Int(limit!)!-row)"
//        }
//    }
//}

