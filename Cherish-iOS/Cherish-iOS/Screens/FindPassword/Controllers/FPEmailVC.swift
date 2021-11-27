//
//  FPEmailVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/17.
//

import UIKit

class FPEmailVC: BaseController {
    
    var isTyped : Bool = false // 이메일 텍스트 필드에 글자 입력이 되었는지
    
    //MARK: -@IBOutlet
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.makeRounded(cornerRadius: 8)
            emailTextField.backgroundColor = .inputGrey
            emailTextField.addLeftPadding()
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var nextBtn: UIButton!{
        didSet{
            nextBtn.makeRounded(cornerRadius: 25)
            nextBtn.backgroundColor = .inputGrey
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkingLetterCount()
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
                if text.count > 0 {
                    greenBtn()
                    isTyped = true
                }else{
                    grayBtn()
                    isTyped = false
                }
            }
        }
    }
    
    // 버튼 초록색(진행 가능함을 의미)
    func greenBtn(){
        nextBtn.backgroundColor = .seaweed
        nextBtn.setTitleColor(.white, for: .normal)
    }
    
    // 버튼 회색(진행 불가함을 의미)
    func grayBtn(){
        nextBtn.backgroundColor = .inputGrey
        nextBtn.setTitleColor(.textGrey, for: .normal)
    }
    
    func emailAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    //MARK: -@IBAction
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextAction(_ sender: Any) {
        // 이메일 입력이 되었다면
        if isTyped{
            /// 해당 이메일로 메시지 전송
            FindPasswordService.shared.findPassword(email: emailTextField.text!) { [self] (networkResult) -> (Void) in
                switch networkResult {
                case .success(let data):
                    if let auth = data as? FindPasswordData {
                        if let vc = self.storyboard?.instantiateViewController(identifier: "FPPhoneVC") as? FPPhoneVC {
                            vc.authNumber = auth.verifyCode
                            vc.email = emailTextField.text!
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                case .requestErr(let msg):
                    if let message = msg as? String {
                        emailAlert(title: "등록되어있지 않은 이메일이에요", message: "다시 확인해주세요")
                        print(emailTextField.text!)
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
extension FPEmailVC: UITextFieldDelegate{

    // Return 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
