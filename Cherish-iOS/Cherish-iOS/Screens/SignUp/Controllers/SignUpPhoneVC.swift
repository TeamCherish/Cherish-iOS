//
//  SignUpPhoneVC.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/10/10.
//

import UIKit
import SnapKit

final class SignUpPhoneVC: BaseController {
    
    // MARK: Components
    
    private lazy var dotStackView = SignUpDotStackView(dotNum: 3, greenDotIdx: 1)
    private lazy var typePhoneNumLabel = UILabel().then {
        $0.setLabel(text: "전화번호를 입력해주세요", color: .black, size: 20, weight: .medium)
    }
    private lazy var typeAuthLabel = UILabel().then {
        $0.setLabel(text: "인증번호를 입력해주세요", color: .black, size: 20, weight: .medium)
    }
    private lazy var phoneNumTextField = SignUpTextField().then {
        $0.setPlaceholder(placeholder: "ex)010-1234-5678")
        $0.textfield.keyboardType = .phonePad
    }
    private lazy var authTextField = SignUpTextField().then {
        $0.setPlaceholder(placeholder: "인증번호 입력")
        $0.textfield.keyboardType = .numberPad
    }
    private lazy var naviBar = BackNaviView().then {
        $0.setTitleLabel(title: "회원가입")
        $0.backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
    private lazy var receiveAuthBtn = CherishBtn().then {
        $0.setButton(bgColor: .systemBackground, textColor: .textGrey, title: "인증번호 받기", size: 16, weight: .regular)
        $0.layer.borderColor = UIColor.textGrey.cgColor
        $0.layer.borderWidth = 1
        $0.press(vibrate: true) {
            self.AuthBtnAction(isResended: false)
        }
    }
    private lazy var resendAuthBtn = CherishBtn().then {
        $0.setButton(bgColor: .white, textColor: .textGrey, title: "재발송", size: 16, weight: .regular)
        $0.layer.borderColor = UIColor.textGrey.cgColor
        $0.layer.borderWidth = 1
        $0.press(vibrate: true) {
            self.AuthBtnAction(isResended: false)
        }
    }
    private lazy var nextBtn = CherishBtn().then {
        $0.setTitleWithStyle(title: "다음", size: 16, weight: .medium)
        $0.press(vibrate: true) {
            self.nextAction()
        }
    }
    
    // MARK: Variables
    
    private let signUpInfo = SignUpInfo.shared
    private var authNumber: Int?
    private var isSending: Bool = false
    private var isAuth: Bool = false
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        self.textFeildDelegate()
        self.phoneNumTextField.textfield.becomeFirstResponder()
    }
}

// MARK: Extension

extension SignUpPhoneVC {
    
    // MARK: Layout
    
    private func setLayout() {
        setNaviLayout()
        setDotsLayout()
        setPhoneAreaLayout()
        setAuthAreaLayout()
        setNextBtnLayout()
    }
    
    private func setNaviLayout() {
        self.view.add(naviBar) {
            $0.snp.makeConstraints {
                $0.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
                $0.height.equalTo(44)
            }
        }
    }
    
    private func setDotsLayout() {
        self.view.add(dotStackView) {
            $0.snp.makeConstraints {
                $0.top.equalTo(self.naviBar.snp.bottom).offset(18)
                $0.left.equalToSuperview().offset(24)
            }
        }
    }
    
    private func setPhoneAreaLayout() {
        self.view.adds([typePhoneNumLabel, phoneNumTextField, receiveAuthBtn]) {
            $0[0].snp.makeConstraints {
                $0.top.equalTo(self.dotStackView.snp.bottom).offset(45)
                $0.left.equalToSuperview().offset(16)
            }
            
            $0[1].snp.makeConstraints {
                $0.top.equalTo(self.typePhoneNumLabel.snp.bottom).offset(4)
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().inset(16)
                $0.height.equalTo(44.adjusted)
            }
            
            $0[2].snp.makeConstraints {
                $0.top.equalTo(self.phoneNumTextField.snp.bottom).offset(28)
                $0.left.right.equalTo(self.phoneNumTextField)
                $0.height.equalTo(self.phoneNumTextField)
            }
            $0[2].makeRounded(cornerRadius: 8.adjusted)
        }
    }
    
    private func setAuthAreaLayout() {
        self.view.adds([typeAuthLabel, authTextField, resendAuthBtn]) {
            $0[0].snp.makeConstraints {
                $0.top.equalTo(self.phoneNumTextField.snp.bottom).offset(38)
                $0.left.equalTo(self.typePhoneNumLabel)
            }
            
            $0[1].snp.makeConstraints {
                $0.top.equalTo(self.typeAuthLabel.snp.bottom).offset(4)
                $0.left.right.equalTo(self.phoneNumTextField)
                $0.height.equalTo(44.adjusted)
            }
            
            $0[2].snp.makeConstraints {
                $0.top.equalTo(self.authTextField.indicatorLabel.snp.bottom).offset(28)
                $0.left.right.equalTo(self.phoneNumTextField)
                $0.height.equalTo(self.phoneNumTextField)
            }
            $0[2].makeRounded(cornerRadius: 8.adjusted)
            self.setInvisible(alpha: 0)
        }
    }
    
    private func setNextBtnLayout() {
        self.view.add(nextBtn) {
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.left.right.equalTo(self.phoneNumTextField)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(33)
                $0.height.equalTo(50.adjusted)
            }
            $0.makeRounded(cornerRadius: 50.adjusted / 2)
        }
    }
    
    // MARK: Button Actions
    
    private func AuthBtnAction(isResended: Bool) {
        if let phoneNumber = phoneNumTextField.textfield.text {
            MessageAuthService.shared.messageAuth(phone: phoneNumber) { [weak self] (networkResult) -> (Void) in
                switch networkResult {
                case .success(let data):
                    self?.authNumber = data as? Int /// 보낸 인증번호
                    self?.isSending = true /// 문자 보냈음
                    if !isResended {
                        self?.animateAuthArea()
                    }
                    self?.authTextField.textfield.becomeFirstResponder()
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
    }
    
    private func nextAction() {
        if isSending && isAuth {
            signUpInfo.phone = phoneNumTextField.textfield.text
            navigationController?.pushViewController(SignUpNicknameVC(), animated: true)
        } else {
            makeAlert(title: "인증을 완료해주세요!", message: nil)
            nextBtn.isActivated = false
            authTextField.textfield.shake()
        }
    }
    
    // MARK: Etc
    
    private func textFeildDelegate() {
        phoneNumTextField.textfield.textDelegate = self
        authTextField.textfield.textDelegate = self
    }
    
    private func setInvisible(alpha: CGFloat) {
        typeAuthLabel.alpha = alpha
        authTextField.alpha = alpha
        resendAuthBtn.alpha = alpha
    }
    
    // 비밀번호 입력부 등장 애니메이션
    private func animateAuthArea(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: { [weak self] in
            self?.receiveAuthBtn.alpha = 0
        }, completion: { _ in
            UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: { [weak self] in
                self?.setInvisible(alpha: 1)
                self?.typeAuthLabel.transform = CGAffineTransform(translationX: 0, y: -10)
                self?.authTextField.transform = CGAffineTransform(translationX: 0, y: -10)
                self?.resendAuthBtn.transform = CGAffineTransform(translationX: 0, y: -10)
            })
        })
    }
}

//MARK: Protocols

extension SignUpPhoneVC: CherishTextFieldDelegate {
    func checkContentsForm(textField: UITextField) {
        switch textField {
        case authTextField.textfield :
            if authTextField.textfield.text ?? "0000" == String(authNumber ?? 9999){
                authTextField.setIndicatorLabel(text: "인증되었습니다.", correct: true)
                nextBtn.isActivated = true
                isAuth = true
                textField.resignFirstResponder()
            }else{
                authTextField.setIndicatorLabel(text: "올바르지 않은 인증번호입니다.", correct: false)
                nextBtn.isActivated = false
                isAuth = false
            }
        default:
            break
        }
    }
}
