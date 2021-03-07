//
//  FPNewPasswordVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/17.
//

import UIKit

class FPNewPasswordVC: UIViewController, UIGestureRecognizerDelegate {
    
    var email: String?
    var passwordFormStatus: Bool = false // 비밀번호 형식 검사
    var passwordStatus : Bool = false // 비밀번호 일치 검사
    
    //MARK: -@IBOutlet
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
    
    //MARK: -사용자 정의 함수
    // 빈 영역 터치시 키보드 내림
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
    
    // 버튼 초록색(진행 가능함을 의미)
    func grayBtn(){
        nextBtn.backgroundColor = .inputGrey
        nextBtn.setTitleColor(.textGrey, for: .normal)
    }
    
    // 버튼 회색(진행 불가함을 의미)
    func greenBtn(){
        nextBtn.backgroundColor = .seaweed
        nextBtn.setTitleColor(.white, for: .normal)
    }
    
    func reTypingAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
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
    
    //MARK: -@IBAction
    // 비밀번호 보이게 하기-입력 부
    @IBAction func firstEyeTouch(_ sender: Any) {
        enterPWTextField.isSecureTextEntry = false
        firstEyeBtn.setImage(UIImage(named: "eye"), for: .normal)
    }
    @IBAction func firstEyeAway(_ sender: Any) {
        enterPWTextField.isSecureTextEntry = true
        firstEyeBtn.setImage(UIImage(named: "eyeOff"), for: .normal)
    }
    
    // 비밀번호 보이게 하기-재입력 부
    @IBAction func secondEyeTouch(_ sender: Any) {
        enterAgainTextField.isSecureTextEntry = false
        secondEyeBtn.setImage(UIImage(named: "eye"), for: .normal)
    }
    @IBAction func secondEyeAway(_ sender: Any) {
        enterAgainTextField.isSecureTextEntry = true
        secondEyeBtn.setImage(UIImage(named: "eyeOff"), for: .normal)
    }
        
    // 뒤로가기
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completeBtn(_ sender: Any) {
        // 비밀번호 일치가 확인 되었다면(형식도 확인된 상태)
        if passwordStatus{
            UpdatePasswordService.shared.updatePW(email: email!, password1: enterPWTextField.text!, password2: enterAgainTextField.text!) { [self] (networkResult) -> (Void) in
                switch networkResult {
                case .success(_):
                    // 비밀번호 변경 성공하면 Login 뷰로 pop
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
            reTypingAlert(title: "사용할 수 없는 비밀번호 입니다", message: "다시 입력해주세요")
        }
    }
}

//MARK: -Protocols
extension FPNewPasswordVC: UITextFieldDelegate{
    ///Return 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == enterPWTextField{
            enterPWTextField.isHidden = false
            let passRegEx = "^(?=.*[a-z])(?=.*[0-9]).{8,}$" // 영문,숫자 포함 8자 이상
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
