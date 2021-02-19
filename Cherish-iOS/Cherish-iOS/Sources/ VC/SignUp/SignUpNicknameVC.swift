//
//  SignUpNicknameVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/16.
//

import UIKit

class SignUpNicknameVC: UIViewController {
    let maxLength_nickname = 8
    var forSignUp = ["","","","",""]
    var gender: Bool = false
    //MARK: -@IBOutlet
    @IBOutlet weak var nickNameTextField: UITextField!{
        didSet{
            nickNameTextField.makeRounded(cornerRadius: 8)
            nickNameTextField.backgroundColor = .inputGrey
            nickNameTextField.addLeftPadding()
            nickNameTextField.delegate = self
        }
    }
    @IBOutlet weak var nickNameCheckLabel: CustomLabel!
    @IBOutlet weak var privacyPolicyBtn: UIButton!
    @IBOutlet weak var termOfServiceBtn: UIButton!
    @IBOutlet weak var startCherishBtn: UIButton!{
        didSet{
            startCherishBtn.makeRounded(cornerRadius: 25.0)
        }
    }
    @IBOutlet weak var beforeImageView: UIImageView!
    @IBOutlet weak var afterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(forSignUp)
        checkingLetterCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 1.0, animations: {
            self.beforeImageView.image = UIImage(named: "joinCircleUnselected")
        },completion: {finished in
            UIView.animate(withDuration: 1.0, animations: {
                self.afterImageView.image = UIImage(named: "joinCircleSelected")
            })
        })
    }
    
    //MARK: -사용자 정의 함수
    
    // 화면 터치시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 글자 수 검사 노티 가진 함수
    func checkingLetterCount(){
        NotificationCenter.default.addObserver(self, selector: #selector(textfieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    // 닉네임 입력 TextField 글자 수 감시(& 복붙 검사)
    @objc private func textfieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                
                if text.count > maxLength_nickname {
                    // 5글자 넘어가면 자동으로 키보드 내려감
                    textField.resignFirstResponder()
                }
                
                // 초과되는 텍스트 제거
                if text.count >= maxLength_nickname {
                    let index = text.index(text.startIndex, offsetBy: maxLength_nickname)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                }
            }
        }
    }
    
    func blankAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    //MARK: @IBAction
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func startCherish(_ sender: Any) {
        if nickNameTextField.text?.count == 0 {
            blankAlert(title: "Cherish", message: "닉네임을 입력해주세요!")
        }else{
            if forSignUp[3]=="남성"{
                gender = true
            }else{
                gender = false
            }
            SignUpService.shared.doSignUp(email: forSignUp[0], password: forSignUp[1], phone: forSignUp[2], sex: "\(gender)", birth: forSignUp[4], nickname: nickNameTextField.text!) { [self] (networkResult) -> (Void) in
                switch networkResult {
                case .success(_):
                    print("sucess")
                    // 회원가입 성공하면 Login 뷰로 pop
                    let controllers = self.navigationController?.viewControllers
                    for vc in controllers! {
                        if vc is LoginVC {
                            _ = self.navigationController?.popToViewController(vc as! LoginVC, animated: true)
                        }
                    }
                    
                case .requestErr(let msg):
                    if let message = msg as? String {
                        print(gender)
                        print(forSignUp)
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

//MARK: -Protocols
/// 1
extension SignUpNicknameVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        //let newKeywordLength = text.count + string.utf16.count - range.length
        
        /// 최대 글자 수 8
        if text.count >= maxLength_nickname && range.length == 0 && range.location < maxLength_nickname {
            return false
        }
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    ///Return 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
