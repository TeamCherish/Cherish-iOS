//
//  FPNewPasswordVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/17.
//

import UIKit

class FPNewPasswordVC: UIViewController, UIGestureRecognizerDelegate {
    
    var isClicked : Bool = false
    var email: String?
    var passwordStatus : Bool = false
    var passwordFormStatus: Bool = false
    var isfirstEyeClicked : Bool = false
    var isSecondEyeClicked : Bool = false
    
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
    @IBOutlet weak var checkingLabel: CustomLabel!{
        didSet{
            checkingLabel.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        checkingLetterCount()
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
    
    // 비밀번호 형식 체크 라벨 관련 함수
    func pwFormLabel(text: String, color: UIColor, form: Bool){
        checkingLabel.text = text
        checkingLabel.textColor = color
        passwordFormStatus = form
        
        // 체크 텍스트필드에 입력한 뒤 위에꺼를 수정하러 온거면 일치 체크해주기
        if (form == true || passwordFormStatus == true) && passwordStatus  == true {
            if enterPWTextField.text == enterAgainTextField.text {
                pwCorrectLabel(text: "비밀번호가 일치합니다.", color: .seaweed, correct: true)
            }else{
                pwCorrectLabel(text: "비밀번호가 일치하지 않습니다.", color: .pinkSub, correct: false)
            }
        }
    }
    
    // 비밀번호 일치 라벨 관련 함수
    func pwCorrectLabel(text: String, color: UIColor, correct: Bool){
        checkingLabel.text = text
        checkingLabel.textColor = color
        passwordStatus = correct
    }
    
    // 비밀번호 보이게 하기-입력 부
    @IBAction func firstEyeAction(_ sender: Any) {
        if !isfirstEyeClicked {
            enterPWTextField.isSecureTextEntry = false
            isfirstEyeClicked = true
        }else{
            enterPWTextField.isSecureTextEntry = true
            isfirstEyeClicked = false
        }
    }
    
    // 비밀번호 보이게 하기-재입력 부
    @IBAction func secondEyeAction(_ sender: Any) {
        if !isSecondEyeClicked {
            enterAgainTextField.isSecureTextEntry = false
            isSecondEyeClicked = true
        }else{
            enterAgainTextField.isSecureTextEntry = true
            isSecondEyeClicked = false
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completeBtn(_ sender: Any) {
        if passwordStatus{
            UpdatePasswordService.shared.updatePW(email: email!, password1: enterPWTextField.text!, password2: enterAgainTextField.text!) { [self] (networkResult) -> (Void) in
                switch networkResult {
                case .success(_):
                    // 회원가입 성공하면 Login 뷰로 pop
                    let controllers = self.navigationController?.viewControllers
                    for vc in controllers! {
                        if vc is LoginVC {
                            _ = self.navigationController?.popToViewController(vc as! LoginVC, animated: true)
                        }
                    }
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
        else{
            //
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
            let passRegEx = "^(?=.*[a-z])(?=.*[0-9]).{8,}$"
            let passTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
            if !passTest.evaluate(with: textField.text){
                pwFormLabel(text: "사용하실 수 없는 비밀번호입니다.", color: .pinkSub, form: false)
            }else{
                pwFormLabel(text: "사용가능한 비밀번호입니다.", color: .seaweed, form: true)
            }
        }
        else if textField == enterAgainTextField{
            if passwordFormStatus{
                if enterPWTextField.text == textField.text {
                    pwCorrectLabel(text: "비밀번호가 일치합니다.", color: .seaweed, correct: true)
                    greenBtn()
                }else{
                    pwCorrectLabel(text: "비밀번호가 일치하지 않습니다.", color: .pinkSub, correct: false)
                    grayBtn()
                }
            }
        }
    }
}
