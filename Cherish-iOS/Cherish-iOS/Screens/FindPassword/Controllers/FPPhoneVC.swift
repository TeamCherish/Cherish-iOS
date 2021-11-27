//
//  FPPhoneVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/17.
//

import UIKit

class FPPhoneVC: BaseController {
    var authNumber : Int? // 인증번호
    var email: String? // 이메일
    var isPassed: Bool = false // 인증번호가 일치하는지
    
    //MARK: -@IBOutlet
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var pleaseTypingLabel: CustomLabel!
    @IBOutlet weak var inputTextField: UITextField!{
        didSet{
            inputTextField.makeRounded(cornerRadius: 8)
            inputTextField.backgroundColor = .inputGrey
            inputTextField.addLeftPadding()
            inputTextField.delegate = self
        }
    }
    @IBOutlet weak var messageCheckLabel: CustomLabel!{
        didSet{
            messageCheckLabel.text = ""
        }
    }
    @IBOutlet weak var resendBtn: UIButton!{
        didSet{
            resendBtn.makeRounded(cornerRadius: 8.0)
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
        setVisible(alpha: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: 10)
        }, completion: { _ in
            // 입력 텍스트 필드 및 재전송 버튼 보이기
            UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: {
                self.setVisible(alpha: 1)
                self.animateGo()
            })
        })

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
    
    func setVisible(alpha: CGFloat){
        self.titleLabel.alpha = alpha
        self.pleaseTypingLabel.alpha = alpha
        self.inputTextField.alpha = alpha
        self.resendBtn.alpha = alpha
        self.messageCheckLabel.alpha = alpha
    }
    
    func animateGo(){
        self.pleaseTypingLabel.transform = CGAffineTransform(translationX: 0, y: 10)
        self.inputTextField.transform = CGAffineTransform(translationX: 0, y: 10)
        self.resendBtn.transform = CGAffineTransform(translationX: 0, y: 10)
        self.messageCheckLabel.transform = CGAffineTransform(translationX: 0, y: 10)
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
    
    // 인증번호 확인 라벨
    func labelStatus(pass: Bool, color: UIColor, text: String){
        isPassed = pass
        messageCheckLabel.textColor = color
        messageCheckLabel.text = text
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
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 재전송
    @IBAction func resendSMS(_ sender: Any) {
        /// 텍스트필드 클리어 및 라벨 멘트
        inputTextField.text = ""
        labelStatus(pass: false, color: .pinkSub, text: "올바르지 않은 인증번호입니다")
        /// 인증번호 재전송
        FindPasswordService.shared.findPassword(email: email!) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let resendAuth = data as? FindPasswordData {
                    authNumber = resendAuth.verifyCode
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
    
    @IBAction func nextAction(_ sender: Any) {
        // 서버랑 통신해서 보내준 인증번호가 맞으면 넘기고 아니면 안넘기도록 분기처리
        if isPassed {
            if let vc = self.storyboard?.instantiateViewController(identifier: "FPNewPasswordVC") as? FPNewPasswordVC {
                vc.email = email
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension FPPhoneVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if inputTextField.text == String(authNumber!){
            labelStatus(pass: true, color: .seaweed, text: "인증되었습니다")
        }else{
            labelStatus(pass: false, color: .pinkSub, text: "올바르지 않은 인증번호입니다")
        }
    }
    // Return 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


