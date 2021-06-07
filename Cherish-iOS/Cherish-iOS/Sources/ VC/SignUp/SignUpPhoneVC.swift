//
//  SignUpPhoneVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/15.
//

import UIKit
import MessageUI

class SignUpPhoneVC: UIViewController, UIGestureRecognizerDelegate {
    //MARK: -변수 선언부
    let signUpInfo = SignUpInfo.shared
    var authNumber: Int?
    var isSending: Bool = false
    var isAuth: Bool = false
    
    //MARK: -@IBOutlet
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var requestMessageBtn: UIButton!
    @IBOutlet weak var pleaseTypingLabel: CustomLabel!
    @IBOutlet weak var typingMessageTextField: UITextField! {
        didSet {
            typingMessageTextField.delegate = self
        }
    }
    @IBOutlet weak var authCheckLabel: UILabel!
    @IBOutlet weak var resendMessageBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK: -viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        setStyle()
        initialSetting(alpha: 0)
    }
    
    // MARK: -@IBAction
    // 인증번호 받기 버튼
    @IBAction func receiveMessage(_ sender: Any) {
        MessageAuthService.shared.messageAuth(phone: phoneTextField.text!) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                authNumber = data as? Int /// 보낸 인증번호
                isSending = true /// 문자 보냈음
                phoneTextField.isEnabled = false /// 번호 입력 부 수정 못하게 비활성화
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
                    phoneTextField.textColor = .textGrey
                    requestMessageBtn.alpha = 0 /// 원래 있던 인증번호보내기 버튼 사라지게 하기
                }, completion: { _ in
                    /// 입력 텍스트 필드 및 재전송 버튼 보이기
                    UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: {
                        initialSetting(alpha: 1)
                        animateGo()
                    })
                })
                greenBtn()
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
    @IBAction func resendAction(_ sender: Any) {
        MessageAuthService.shared.messageAuth(phone: phoneTextField.text!) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                self.basicAlert(title: "인증번호가 재전송 되었습니다.", message: nil)
                authNumber = data as? Int
                isSending = true
                
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
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextAction(_ sender: Any) {
        // 인증완료 되었으면 넘기기
        if isSending && isAuth {
            if let vc = self.storyboard?.instantiateViewController(identifier: "SignUpNicknameVC") as? SignUpNicknameVC {
                if let phone = phoneTextField.text {
                    signUpInfo.phone = phone
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

extension SignUpPhoneVC {
    //화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: -사용자 정의 함수
    func setStyle() {
        phoneTextField.makeRounded(cornerRadius: 8)
        phoneTextField.addLeftPadding()
        phoneTextField.backgroundColor = .inputGrey
        requestMessageBtn.makeRounded(cornerRadius: 8)
        requestMessageBtn.layer.borderColor = UIColor.textGrey.cgColor
        requestMessageBtn.layer.borderWidth  = 1.0
        typingMessageTextField.makeRounded(cornerRadius: 8)
        typingMessageTextField.addLeftPadding()
        typingMessageTextField.backgroundColor = .inputGrey
        authCheckLabel.isHidden = true
        resendMessageBtn.makeRounded(cornerRadius: 8)
        resendMessageBtn.layer.borderColor = UIColor.textGrey.cgColor
        resendMessageBtn.layer.borderWidth  = 1.0
        nextBtn.makeRounded(cornerRadius: 25.0)
        nextBtn.backgroundColor = .inputGrey
    }
    
    func initialSetting(alpha: CGFloat){
        pleaseTypingLabel.alpha = alpha
        typingMessageTextField.alpha = alpha
        resendMessageBtn.alpha = alpha
    }
    
    // 인증번호 입력 등장 애니메이션
    func animateGo(){
        self.pleaseTypingLabel.transform = CGAffineTransform(translationX: 0, y: -10)
        self.typingMessageTextField.transform = CGAffineTransform(translationX: 0, y: -10)
        self.resendMessageBtn.transform = CGAffineTransform(translationX: 0, y: -10)
    }
    
    // 초록색으로 채워진 버튼
    func greenBtn(){
        nextBtn.backgroundColor = .seaweed
        nextBtn.setTitleColor(.white, for: .normal)
    }
    
    // 인증 UI 관련 메소드
    func authLabel(see: Bool, text: String, color: UIColor, authStatus: Bool) {
        authCheckLabel.isHidden = see
        authCheckLabel.text = text
        authCheckLabel.textColor = color
        isAuth = authStatus
    }
}

//MARK: -Protocols
extension SignUpPhoneVC: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == typingMessageTextField{
            if typingMessageTextField.text! == String(authNumber!){
                authLabel(see: false, text: "인증되었습니다.", color: .seaweed, authStatus: true)
            }else{
                authLabel(see: false, text: "올바르지 않은 인증번호입니다.", color: .pinkSub, authStatus: false)
            }
        }
    }
    
    // Return 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
