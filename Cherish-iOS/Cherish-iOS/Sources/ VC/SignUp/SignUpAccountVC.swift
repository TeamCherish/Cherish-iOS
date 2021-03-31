//
//  SignUpAccountVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/15.
//

import UIKit


class SignUpAccountVC: UIViewController, UIGestureRecognizerDelegate {
    
    var isEmail : Bool? = false // 중복 확인용
    var isPossibleEmail : Bool? = false // 이메일 형식 통과 확인용
    var passwordStatus: Bool? =   false // 비밀번호 일치 확인용
    var passwordFormStatus : Bool? = false // 비밀번호 통과 확인용
    
    //MARK: @IBOutlet
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.addLeftPadding()
            emailTextField.backgroundColor = .inputGrey
            emailTextField.makeRounded(cornerRadius: 8)
        }
    }
    @IBOutlet weak var emailCheckBtn: UIButton!{
        didSet{
            emailCheckBtn.makeRounded(cornerRadius: 25.0)
            emailCheckBtn.backgroundColor = .inputGrey
        }
    }
    @IBOutlet weak var emailCheckLabel: CustomLabel!
    @IBOutlet weak var pleasePasswordLabel: CustomLabel!
    @IBOutlet weak var firstEyeBtn: UIButton!
    @IBOutlet weak var secondEyeBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.addLeftPadding()
            passwordTextField.backgroundColor = .inputGrey
            passwordTextField.makeRounded(cornerRadius: 8)
        }
    }
    @IBOutlet weak var passwordCheckTextField: UITextField!{
        didSet{
            passwordCheckTextField.addLeftPadding()
            passwordCheckTextField.backgroundColor = .inputGrey
            passwordCheckTextField.makeRounded(cornerRadius: 8)
        }
    }
    @IBOutlet weak var passwordCheckLabel: CustomLabel!
    @IBOutlet weak var forChangeImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        beforeEmail()
        textFeildRight()
    }
    
    //MARK: -사용자 정의 함수
    ///화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setHidden(alpha: CGFloat){
        pleasePasswordLabel.alpha = alpha
        passwordTextField.alpha = alpha
        firstEyeBtn.alpha = alpha
        passwordCheckTextField.alpha = alpha
        secondEyeBtn.alpha = alpha
    }
    
    // 이메일 입력하기 전까지는 안보이기
    func beforeEmail(){
        emailCheckLabel.isHidden = true
        passwordCheckLabel.isHidden = true
        setHidden(alpha: 0)
    }
    
    // 비밀번호 입력부 등장 애니메이션
    func animateGo(){
        self.pleasePasswordLabel.transform = CGAffineTransform(translationX: 0, y: -10)
        self.passwordTextField.transform = CGAffineTransform(translationX: 0, y: -10)
        self.firstEyeBtn.transform = CGAffineTransform(translationX: 0, y: -10)
        self.passwordCheckTextField.transform = CGAffineTransform(translationX: 0, y: -10)
        self.secondEyeBtn.transform = CGAffineTransform(translationX: 0, y: -10)
    }
    
    // textField Delegates
    func textFeildRight(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
    }
    
    // 완료버튼 초록색으로 변경(진행 가능함을 의미)
    func greenBtn(){
        emailCheckBtn.backgroundColor = .seaweed
        emailCheckBtn.setTitleColor(.white, for: .normal)
    }
    
    // 완료버튼 회색 변경(진행 불가함을 의미)
    func grayBtn(){
        emailCheckBtn.backgroundColor = .inputGrey
        emailCheckBtn.setTitleColor(.textGrey, for: .normal)
    }
    
    // 이메일 형식 체크 라벨 관련 함수
    func emailFormLabel(text: String, color: UIColor, form: Bool){
        emailCheckLabel.text = text
        emailCheckLabel.textColor = color
        isPossibleEmail = form
    }
    
    // 비밀번호 형식 체크 라벨 관련 함수
    func pwFormLabel(text: String, color: UIColor, form: Bool){
        passwordCheckLabel.text = text
        passwordCheckLabel.textColor = color
        passwordFormStatus = form
        
        // 체크 텍스트필드에 입력한 뒤 위에꺼를 수정하러 온거면 일치 체크해주기
        if (form == true || passwordFormStatus == true) && passwordStatus  == true {
            if passwordTextField.text == passwordCheckTextField.text {
                pwCorrectLabel(text: "비밀번호가 일치합니다.", color: .seaweed, correct: true)
            }else{
                pwCorrectLabel(text: "비밀번호가 일치하지 않습니다.", color: .pinkSub, correct: false)
            }
        }
    }
    
    // 비밀번호 일치 라벨 관련 함수
    func pwCorrectLabel(text: String, color: UIColor, correct: Bool){
        passwordCheckLabel.text = text
        passwordCheckLabel.textColor = color
        passwordStatus = correct
    }
    
    //MARK: -@IBAction
    @IBAction func nextPage(_ sender: Any) {
        if isEmail == true{
            // 이메일 중복확인이 끝났고 비밀번호도 입력이 끝났다면
            if passwordStatus == true {
                if let vc = self.storyboard?.instantiateViewController(identifier: "SignUpPhoneVC") as? SignUpPhoneVC {
                    vc.forSending[0] = emailTextField.text!
                    vc.forSending[1] = passwordCheckTextField.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                //비밀번호를 입력해주세요
            }
        }else{
            // 이메일 중복확인을 아직 안했다면
            if isPossibleEmail == true {
                // 이메일 중복 체크 코드
                CheckEmailService.shared.checkEmail(email: emailTextField.text!) { [self] (networkResult) -> (Void) in
                    switch networkResult {
                    case .success(_):
                        
                        // 이메일 수정 못하게 Enable
                        emailTextField.isEnabled = false
                        
                        UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: {
                            emailTextField.textColor = .textGrey
                        }, completion: { _ in
                            UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: {
                                    setHidden(alpha: 1)
                                    animateGo()
                            })
                        })
                        
                        grayBtn()
                        emailCheckLabel.text = "사용가능한 이메일입니다."
                        emailCheckLabel.textColor = .seaweed
                        
                        isEmail = true // 중복 검사 완료
                    
                    case .requestErr(let msg):
                        if let message = msg as? String {
                            emailCheckLabel.text = "이미 등록된 이메일입니다."
                            emailCheckLabel.textColor = .pinkSub
                            isEmail = false // 중복 검사 불통과
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
        }
    }
    
    //MARK: -Secure Text Entry
    // First Eye
    // 터치하고 있으면 비밀번호 보여주기
    @IBAction func firstEyeTouch(_ sender: Any) {
        passwordTextField.isSecureTextEntry = false
        firstEyeBtn.setImage(UIImage(named: "eye"), for: .normal)
    }
    // 버튼에서 손을 떼면 다시 감추기
    @IBAction func firstEyeAway(_ sender: Any) {
        passwordTextField.isSecureTextEntry = true
        firstEyeBtn.setImage(UIImage(named: "eyeOff"), for: .normal)
    }
    // 터치를 유지한채로 버튼 영역 밖으로 벗어났을 경우
    @IBAction func firstEyeTouchAway(_ sender: Any) {
        passwordTextField.isSecureTextEntry = true
        firstEyeBtn.setImage(UIImage(named: "eyeOff"), for: .normal)
    }
    
    // Second Eye
    @IBAction func secondEyeTouch(_ sender: Any) {
        passwordCheckTextField.isSecureTextEntry = false
        secondEyeBtn.setImage(UIImage(named: "eye"), for: .normal)
    }
    @IBAction func secondEyeAway(_ sender: Any) {
        passwordCheckTextField.isSecureTextEntry = true
        secondEyeBtn.setImage(UIImage(named: "eyeOff"), for: .normal)
    }
    @IBAction func secondEyeTouchAway(_ sender: Any) {
        passwordCheckTextField.isSecureTextEntry = true
        secondEyeBtn.setImage(UIImage(named: "eyeOff"), for: .normal)
    }
    
   
    // 뒤로가기
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: -Protocols
/// 1
extension SignUpAccountVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField{
            emailCheckLabel.isHidden = false
            let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluate(with: textField.text){
                emailFormLabel(text: "사용할 수 없는 형식입니다.", color: .pinkSub, form: false)
                grayBtn()
            }else{
                emailFormLabel(text: "사용가능한 이메일 형식입니다.", color: .seaweed, form: true)
                greenBtn()
            }
        }
        // 1번 텍스트 필드
        else if textField == passwordTextField{
            // 비밀번호가 영문 ,숫자,특수문자 포함 8글자인지
            passwordCheckLabel.isHidden = false
            let passRegEx = "^(?=.*[a-z])(?=.*[0-9])(?=.*[\\[\\]~!@#$%^&*()=+{}:?,<>/._-]).{8,}$"
            let passTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
            if !passTest.evaluate(with: textField.text){
                pwFormLabel(text: "사용하실 수 없는 비밀번호입니다.", color: .pinkSub, form: false)
            }else{
                pwFormLabel(text: "사용가능한 비밀번호입니다.", color: .seaweed, form: true)
                // 1번,2번 다 입력했는데 1번이 의도치 않게 오타나서 1번을 2번과 일치하게 바꾸면
                // 1번 텍스트 필드에서도 일치 검사를 해야하는 상황이 있음
                if textField.text == passwordCheckTextField.text {
                    pwCorrectLabel(text: "비밀번호가 일치합니다.", color: .seaweed, correct: true)
                    greenBtn()
                }
            }
        }
        // 2번 텍스트 필드
        else if textField == passwordCheckTextField{
            // 형식을 통과했으며, 비밀번호가 일치하는지
            if passwordFormStatus == true {
                if passwordTextField.text == textField.text {
                    pwCorrectLabel(text: "비밀번호가 일치합니다.", color: .seaweed, correct: true)
                    greenBtn()
                }else{
                    pwCorrectLabel(text: "비밀번호가 일치하지 않습니다.", color: .pinkSub, correct: false)
                    grayBtn()
                }
            }
        }
    }
    
    ///Return 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
