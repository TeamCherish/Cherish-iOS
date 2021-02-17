//
//  FPNewPasswordVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/17.
//

import UIKit

class FPNewPasswordVC: UIViewController {
    
    var isClicked : Bool = false
    var passwordStatus : Bool = false
    
    @IBOutlet weak var enterPWTextField: UITextField!{
        didSet{
            enterPWTextField.makeRounded(cornerRadius: 8)
            enterPWTextField.backgroundColor = .inputGrey
            enterPWTextField.addLeftPadding()
            enterPWTextField.delegate = self
        }
    }
    @IBOutlet weak var enterAgainTextField: UITextField!{
        didSet{
            enterAgainTextField.makeRounded(cornerRadius: 8)
            enterAgainTextField.backgroundColor = .inputGrey
            enterAgainTextField.addLeftPadding()
            enterAgainTextField.delegate = self
        }
    }
    @IBOutlet weak var nextBtn: UIButton!{
        didSet{
            nextBtn.makeRounded(cornerRadius: 25)
            nextBtn.backgroundColor = .inputGrey
        }
    }
    @IBOutlet weak var firstEyeBtn: UIButton!
    @IBOutlet weak var secondEyeBtn: UIButton!
    @IBOutlet weak var checkingLabel: CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 글자 수 검사 노티 가진 함수
    func checkingLetterCount(){
        NotificationCenter.default.addObserver(self, selector: #selector(textfieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    // 닉네임 입력 TextField 글자 수 감시(& 복붙 검사)
    @objc private func textfieldDidChange(_ notification: Notification) {
        if (notification.object as? UITextField) != nil {
            if passwordStatus {
                greenBtn()
            }else{
                grayBtn()
            }
        }
    }
    
    func grayBtn(){
        nextBtn.backgroundColor = .inputGrey
        nextBtn.setTitleColor(.textGrey, for: .normal)
    }
    
    func greenBtn(){
        nextBtn.backgroundColor = .seaweed
        nextBtn.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func completeBtn(_ sender: Any) {
        if passwordStatus{
            nextBtn.isEnabled = true
            // 변경 완료
        }else{
            nextBtn.isEnabled = false
        }
    }
}
extension FPNewPasswordVC: UITextFieldDelegate{
    ///Return 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         if textField == enterPWTextField{
            enterPWTextField.isHidden = false
            let passRegEx = "^(?=.*[a-z])(?=.*[0-9]).{8}$"
            let passTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
            if !passTest.evaluate(with: textField.text){
                enterPWTextField.text = "사용하실 수 없는 비밀번호입니다."
                enterPWTextField.textColor = .pinkSub
                passwordStatus = false
            }else{
                enterPWTextField.text = "사용가능한 비밀번호입니다."
                enterPWTextField.textColor = .seaweed
            }
        }
        else if textField == enterAgainTextField{
            if enterAgainTextField.text == textField.text {
                enterAgainTextField.text = "비밀번호가 일치합니다."
                enterAgainTextField.textColor = .seaweed
                passwordStatus = true
            }else{
                enterAgainTextField.text = "비밀번호가 일치하지 않습니다."
                enterAgainTextField.textColor = .pinkSub
                passwordStatus = false
            }
        }
    }
}
