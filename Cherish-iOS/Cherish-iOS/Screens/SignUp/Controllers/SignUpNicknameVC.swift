//
//  SignUpNicknameVC.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/10/10.
//

import UIKit
import SnapKit
import SafariServices

final class SignUpNicknameVC: UIViewController, SFSafariViewControllerDelegate, UIGestureRecognizerDelegate {
    
    // MARK: Components
    
    private lazy var dotStackView = SignUpDotStackView(dotNum: 3, greenDotIdx: 2)
    private lazy var typeNicknameLabel = UILabel().then {
        $0.setLabel(text: "사용할 닉네임을 입력해주세요", color: .black, size: 20, weight: .medium)
    }
    private lazy var privacyModifierLabel = UILabel().then {
        $0.setLabel(text: "‘시작하기'버튼을 누르면 cherish의 ", color: .black, size: 12, weight: .regular)
    }
    private lazy var andLabel = UILabel().then {
        $0.setLabel(text: "과", color: .black, size: 12, weight: .regular)
    }
    private lazy var termsModifierLabel = UILabel().then {
        $0.setLabel(text: "을 읽고 동의한 것으로 간주합니다.", color: .black, size: 12, weight: .regular)
    }
    private lazy var naviBar = BackNaviView().then {
        $0.setTitleLabel(title: "회원가입")
        $0.backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
    private lazy var startBtn = CherishBtn().then {
        $0.setButton(bgColor: .inputGrey, textColor: .textGrey, title: "시작하기", size: 16, weight: .bold)
        $0.press(vibrate: true) {
            self.startCherishAction()
        }
    }
    private lazy var nicknameTextField = SignUpTextField().then {
        $0.setPlaceholder(placeholder: "최대 8글자")
        $0.textfield.delegate = self
    }
    private lazy var privacyBtn = CherishBtn().then {
        $0.setButton(bgColor: .clear, textColor: .seaweed, title: "개인정보보호 정책", size: 12, weight: .bold)
        $0.makeRounded(cornerRadius: 0)
        $0.press(vibrate: true) {
            self.privacyBtnAction()
        }
    }
    
    private lazy var termsOfPolicyBtn = CherishBtn().then {
        $0.setButton(bgColor: .clear, textColor: .seaweed, title: "서비스 이용 약관", size: 12, weight: .bold)
        $0.makeRounded(cornerRadius: 0)
        $0.press(vibrate: true) {
            self.termsOfServiceBtnAction()
        }
    }
    private lazy var warningStackView = UIStackView().then {
        let privacyStackView = UIStackView().then {
            $0.addArrangedSubview(privacyModifierLabel)
            $0.addArrangedSubview(privacyBtn)
            $0.addArrangedSubview(andLabel)
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.spacing = 0
        }
        
        let termsStackView = UIStackView().then {
            $0.addArrangedSubview(termsOfPolicyBtn)
            $0.addArrangedSubview(termsModifierLabel)
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.spacing = 0
        }
        
        $0.addArrangedSubview(privacyStackView)
        $0.addArrangedSubview(termsStackView)
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 0
    }
    
    // MARK: Variables
    
    private let maxLength_nickname = 8
    private let signUpInfo = SignUpInfo.shared
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.setLayout()
        // 글자 수 검사 노티 가진 함수
        NotificationCenter.default.addObserver(self, selector: #selector(textfieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: Extension

extension SignUpNicknameVC {
    
    // MARK: Layout
    
    private func setLayout() {
        setNaviLayout()
        setDotsLayout()
        setNicknameAreaLayout()
        setStartBtnLayout()
        setWarningLabelsLayout()
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
    
    private func setNicknameAreaLayout() {
        self.view.adds([typeNicknameLabel, nicknameTextField]) {
            $0[0].snp.makeConstraints {
                $0.top.equalTo(self.dotStackView.snp.bottom).offset(45)
                $0.left.equalToSuperview().offset(16)
            }
            
            
            $0[1].snp.makeConstraints {
                $0.top.equalTo(self.typeNicknameLabel.snp.bottom).offset(4)
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().inset(16)
                $0.height.equalTo(44.adjusted)
            }
        }
    }
    
    private func setStartBtnLayout() {
        self.view.add(startBtn) {
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.left.right.equalTo(self.nicknameTextField)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(33)
                $0.height.equalTo(50.adjusted)
            }
            $0.makeRounded(cornerRadius: 50.adjusted / 2)
        }
    }
    
    private func setWarningLabelsLayout() {
        self.view.add(warningStackView) {
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(self.startBtn.snp.top).offset(-26)
                $0.height.equalTo(36.adjusted)
            }
        }
    }
    
    // MARK: Button Actions
    
    private func startCherishAction() {
        if let nickName = nicknameTextField.textfield.text {
            signUpInfo.nickName = nickName
            if let email = signUpInfo.email, let password = signUpInfo.password, let phone = signUpInfo.phone, let nickName = signUpInfo.nickName {
                // 성별, 생년원일 수집은 개인정보보호정책에 의해 잠시 중단
                SignUpService.shared.doSignUp(email: email, password: password, phone: phone, sex: "True", birth: "0000-00-00", nickname: nickName) { [self] (networkResult) -> (Void) in
                    switch networkResult {
                    case .success(_):
                        // 회원가입 성공하면 Login 뷰로 pop
                        let controllers = self.navigationController?.viewControllers
                        for vc in controllers! {
                            if vc is LoginVC {
                                _ = self.navigationController?.popToViewController(vc as! LoginVC, animated: true)
                            }
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
            } else {
                print("정보 누락")
            }
        } else {
            self.basicAlert(title: "닉네임을 입력해주세요!", message: nil)
        }
    }
    
    private func privacyBtnAction() {
        if let url = URL(string: "https://www.notion.so/Cherish-2d35c1bffa2f4d49943db302d76e3cac") {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            vc.modalPresentationStyle = .popover
            present(vc, animated: true)
        }
    }
    
    private func termsOfServiceBtnAction() {
        if let url = URL(string: "https://www.notion.so/Cherish-d96f88172ffa4d80b257665849bddc65") {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            vc.modalPresentationStyle = .popover
            present(vc, animated: true)
        }
    }
    
    // MARK: Etc
    
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
}

//MARK: -Protocols
extension SignUpNicknameVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        // 최대 글자 수 8
        if text.count >= maxLength_nickname && range.length == 0 && range.location < maxLength_nickname {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 0 {
            nicknameTextField.setIndicatorLabel(text: "사용하실 수 있는 닉네임입니다.", correct: true)
            startBtn.changeColors(bgColor: .seaweed, textColor: .white)
        }else{
            nicknameTextField.setIndicatorLabel(text: "닉네임을 입력해주세요.", correct: false)
            startBtn.changeColors(bgColor: .inputGrey, textColor: .textGrey)
        }
    }
    
    // Return 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
