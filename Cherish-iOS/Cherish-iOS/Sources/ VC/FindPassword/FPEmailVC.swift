//
//  FPEmailVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/17.
//

import UIKit

class FPEmailVC: UIViewController, UIGestureRecognizerDelegate {
    var isFinished : Bool = false
    
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
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        checkingLetterCount()
    }
    
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
                    isFinished = true
                }else{
                    grayBtn()
                    isFinished = false
                }
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
    
    func emailAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextAction(_ sender: Any) {
        if isFinished{
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

extension FPEmailVC: UITextFieldDelegate{

    ///Return 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
