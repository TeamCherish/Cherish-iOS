//
//  SignUpAccountVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/15.
//

import UIKit


class SignUpAccountVC: UIViewController {
    
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
    
    var isEmail : Bool? = false // 중복 확인용
    var isPossibleEmail : Bool? = false // 이메일 형식 통과 확인용
    var passwordStatus : Bool? = false // 비밀번호 통과 확인용
    var isfirstEyeClicked : Bool = false
    var isSecondEyeClicked : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beforeEmail()
        textFeildRight()
        //        self.testImageView.image = UIImage.gif(name: "testwatering")!
        //        self.testImageView.alpha = 0.7
        //        UIView.animate(withDuration: 4, animations:
        //       {
        //            self.testImageView.alpha = 0.0
        //       })
    }
    
    ///화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setHidden(status: Bool){
        pleasePasswordLabel.isHidden = status
        passwordTextField.isHidden = status
        firstEyeBtn.isHidden = status
        passwordCheckTextField.isHidden = status
        secondEyeBtn.isHidden = status
    }
    
    // 이메일 입력하기 전까지는 안보이기
    func beforeEmail(){
        emailCheckLabel.isHidden = true
        passwordCheckLabel.isHidden = true
        setHidden(status: true)
    }
    
    func textFeildRight(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
    }
    
    @IBAction func nextPage(_ sender: Any) {
        // 이메일 중복확인이 끝났고 비밀번호도 입력이 끝났다면
        if isEmail == true{
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
            if isPossibleEmail == true {
                // 이메일 중복 체크 코드
                CheckEmailService.shared.checkEmail(email: emailTextField.text!) { [self] (networkResult) -> (Void) in
                    switch networkResult {
                    case .success(_):
                        
                        setHidden(status: false)
                        emailCheckBtn.backgroundColor = .seaweed
                        emailCheckBtn.setTitleColor(.white, for: .normal)
                        emailCheckLabel.text = "사용가능한 이메일입니다."
                        emailCheckLabel.textColor = .seaweed
                        
                        // 이메일 수정 못하게 Enable
                        emailTextField.isEnabled = false
                        emailTextField.textColor = .textGrey
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
    @IBAction func firstEyeAction(_ sender: Any) {
        if isfirstEyeClicked{
            passwordTextField.isSecureTextEntry = true
            firstEyeBtn.setImage(UIImage(named: "eyeOff"), for: .normal)
            isfirstEyeClicked = false
        }else{
            passwordTextField.isSecureTextEntry = false
            firstEyeBtn.setImage(UIImage(named: "eye"), for: .normal)
            isfirstEyeClicked = true
        }
    }
    
    @IBAction func secondEyeAction(_ sender: Any) {
        if isSecondEyeClicked{
            passwordCheckTextField.isSecureTextEntry = true
            secondEyeBtn.setImage(UIImage(named: "eyeOff"), for: .normal)
            isSecondEyeClicked = false
        }else{
            passwordCheckTextField.isSecureTextEntry = false
            secondEyeBtn.setImage(UIImage(named: "eye"), for: .normal)
            isSecondEyeClicked = true
        }
    }
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
                emailCheckLabel.text = "사용할 수 없는 형식입니다."
                emailCheckLabel.textColor = .pinkSub
                isPossibleEmail = false
            }else{
                emailCheckLabel.text = "사용가능한 이메일입니다."
                emailCheckLabel.textColor = .seaweed
                isPossibleEmail = true
            }
        }
        else if textField == passwordTextField{
            passwordCheckLabel.isHidden = false
            let passRegEx = "^(?=.*[a-z])(?=.*[0-9]).{8}$"
            let passTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
            if !passTest.evaluate(with: textField.text){
                passwordCheckLabel.text = "사용하실 수 없는 비밀번호입니다."
                passwordCheckLabel.textColor = .pinkSub
                passwordStatus = false
            }else{
                passwordCheckLabel.text = "사용가능한 비밀번호입니다."
                passwordCheckLabel.textColor = .seaweed
            }
        }
        else if textField == passwordCheckTextField{
            if passwordTextField.text == textField.text {
                passwordCheckLabel.text = "비밀번호가 일치합니다."
                passwordCheckLabel.textColor = .seaweed
                passwordStatus = true
            }else{
                passwordCheckLabel.text = "비밀번호가 일치하지 않습니다."
                passwordCheckLabel.textColor = .pinkSub
                passwordStatus = false
            }
        }
    }
    
    
    ///Return 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
