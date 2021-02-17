//
//  FPPhoneVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/17.
//

import UIKit

class FPPhoneVC: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!{
        didSet{
            inputTextField.makeRounded(cornerRadius: 8)
            inputTextField.backgroundColor = .inputGrey
            inputTextField.addLeftPadding()
            inputTextField.delegate = self
        }
    }
    @IBOutlet weak var resendBtn: UIButton!{
        didSet{
            resendBtn.makeRounded(cornerRadius: 25)
            resendBtn.layer.borderColor = UIColor.textGrey.cgColor
            resendBtn.layer.borderWidth  = 1.0
        }
    }
    @IBOutlet weak var nextBtn: UIButton!{
        didSet{
            nextBtn.makeRounded(cornerRadius: 25.0)
            nextBtn.backgroundColor = .inputGrey
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                if text.count > 0 {
                    greenBtn()
                }else{
                    grayBtn()
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
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 재전송
    @IBAction func resendSMS(_ sender: Any) {
        /// 텍스트필드 클리어
        inputTextField.text = ""
    }
    
    @IBAction func nextAction(_ sender: Any) {
        // 서버랑 통신해서 보내준 인증번호가 맞으면 넘기고 아니면 안넘기도록 분기처리
    }
}

extension FPPhoneVC: UITextFieldDelegate{
    ///Return 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


