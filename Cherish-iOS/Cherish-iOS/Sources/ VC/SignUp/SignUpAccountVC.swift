//
//  SignUpMainVC.swift
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
    
    var isEmail : Bool?
    var emailStatus : Bool?
    var passwordStatus : Bool?
    var isfirstEyeClicked : Bool = false
    var isSecondEyeClicked : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beforeEmail()
        textFeildRight()
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
        // 비밀번호까지 입력 다 했다면
        if isEmail == true{
            let storyboard: UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
            if let vc = storyboard.instantiateViewController(identifier: "SignUpPhoneVC") as? SignUpPhoneVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            // 이메일 중복 체크 코드 필요
            // 중복 아니면 emailCheckLabel.isHidden = false && emailStatus = true
            // 중복이면 멘트 변경 && emailStatus = false
            setHidden(status: false)
            isEmail = true
            emailCheckBtn.backgroundColor = .seaweed
            emailCheckBtn.setTitleColor(.white, for: .normal)
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
    /// 키워드 부분 글자수 Counting
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //    }
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //
    //    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField{
            emailCheckLabel.isHidden = false
            let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluate(with: textField.text){
                emailCheckLabel.text = "사용할 수 없는 형식입니다."
                emailCheckLabel.textColor = .pinkSub
                emailStatus = false
            }else{
                emailCheckLabel.text = "사용가능한 이메일입니다."
                emailCheckLabel.textColor = .seaweed
                emailStatus = true
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
