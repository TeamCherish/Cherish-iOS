//
//  SignUpAccountVC.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/10/09.
//

import UIKit
import SnapKit

final class SignUpAccountVC: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Components
    
    private lazy var dotStackView = SignUpDotStackView(dotNum: 3, greenDotIdx: 0)
    private lazy var typeEmailLabel = UILabel().then {
        $0.setLabel(text: "이메일을 입력해주세요", color: .black, size: 20, weight: .medium)
    }
    private lazy var typePasswordLabel = UILabel().then {
        $0.setLabel(text: "비밀번호를 입력해주세요", color: .black, size: 20, weight: .medium)
    }
    private lazy var emailTextField = SignUpTextField().then {
        $0.setPlaceholder(placeholder: "ex) cherish@naver.com")
        $0.textfield.keyboardType = .emailAddress
    }
    private lazy var pwTextField = SignUpTextField().then {
        $0.setPlaceholder(placeholder: "영문, 숫자 포함 8자이상")
        $0.changeSecureMode()
    }
    private lazy var pwReTextField = SignUpTextField().then {
        $0.setPlaceholder(placeholder: "비밀번호를 다시 입력해주세요")
        $0.changeSecureMode()
    }
    private lazy var naviBar = BackNaviView().then {
        $0.setTitleLabel(title: "회원가입")
        $0.backBtn.press {
            self.dismiss(animated: true)
        }
    }
    // TODO: 눈모양 버튼 클릭시 버튼이미지 변경되어야 함
    private lazy var firstEyeBtn = UIButton().then {
        $0.setImageByName(name: "eyeOff", selectedName: nil)
        $0.press {
            self.reversalEyeBtn()
        }
    }
    private lazy var secEyeBtn = UIButton().then {
        $0.setImageByName(name: "eyeOff", selectedName: nil)
        $0.press {
            self.reversalEyeBtn()
        }
    }
    private lazy var nextBtn = CherishBtn().then {
        $0.setButton(bgColor: .inputGrey, textColor: .textGrey, title: "다음", size: 16, weight: .bold)
        $0.press(vibrate: true) {
            self.nextBtnAction()
        }
    }
    
    // MARK: Variables
    
    private let signUpInfo = SignUpInfo.shared
    private var isEmail : Bool = false // 중복 확인용
    private var isPossibleEmail : Bool = false // 이메일 형식 통과 확인용
    private var isCorrectPw: Bool =  false // 비밀번호 일치 확인용
    private var isPossiblePw : Bool = false // 비밀번호 통과 확인용
    private enum ButtonState {
        case correct, incorrect
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.setLayout()
        self.textFeildDelegate()
        self.setInvisible(alpha: 0)
    }
}

// MARK: Extension

extension SignUpAccountVC {
    
    // MARK: Layout
    
    private func setLayout() {
        setNaviLayout()
        setDotsLayout()
        setEmailAreaLayout()
        setPwAreaLayout()
        setPwEyeBtnLayout()
        setNextBtnLayout()
    }
    
    private func setNaviLayout() {
        self.view.add(naviBar) {
            $0.backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
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
    
    private func setEmailAreaLayout() {
        self.view.adds([typeEmailLabel, emailTextField]) {
            $0[0].snp.makeConstraints {
                $0.top.equalTo(self.dotStackView.snp.bottom).offset(45)
                $0.left.equalToSuperview().offset(16)
            }
            
            $0[1].snp.makeConstraints {
                $0.top.equalTo(self.typeEmailLabel.snp.bottom).offset(4)
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().inset(16)
                $0.height.equalTo(44.adjusted)
            }
        }
    }
    
    private func setPwAreaLayout() {
        self.view.adds([typePasswordLabel, pwTextField, pwReTextField]) {
            $0[0].snp.makeConstraints {
                $0.top.equalTo(self.emailTextField.indicatorLabel.snp.bottom).offset(14)
                $0.left.equalTo(self.emailTextField)
            }
            
            $0[1].snp.makeConstraints {
                $0.top.equalTo(self.typePasswordLabel.snp.bottom).offset(4)
                $0.left.right.equalTo(self.emailTextField)
                $0.height.equalTo(44.adjusted)
            }

            $0[2].snp.makeConstraints {
                $0.top.equalTo(self.pwTextField.snp.bottom).offset(13)
                $0.left.right.equalTo(self.emailTextField)
                $0.height.equalTo(44.adjusted)
            }
        }
    }
    
    private func setPwEyeBtnLayout() {
        self.pwTextField.add(firstEyeBtn) {
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().inset(10)
            }
        }
        
        self.pwReTextField.add(secEyeBtn) {
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().inset(10)
            }
        }
    }
    
    private func setNextBtnLayout() {
        self.view.add(nextBtn) {
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.left.right.equalTo(self.emailTextField)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(33)
                $0.height.equalTo(50.adjusted)
            }
        }
    }
    
    // MARK: Button Action
    
    private func nextBtnAction() {
        
        // 이메일 중복확인이 끝났고 비밀번호도 입력이 끝났다면
        if isEmail {
            if isCorrectPw  {
                self.signUpInfo.email = emailTextField.textfield.text
                self.signUpInfo.password = pwReTextField.textfield.text
                self.navigationController?.pushViewController(SignUpPhoneVC(), animated: true)
            } else {
                self.basicAlert(title: "비밀번호를 입력해주세요", message: nil)
            }
        } else {
            // 이메일 중복확인을 아직 안했다면
            if isPossibleEmail {
                /// 이메일 중복 체크 코드
                if let email = emailTextField.textfield.text {
                    CheckEmailService.shared.checkEmail(email: email) { [weak self] (networkResult) -> (Void) in
                        switch networkResult {
                        case .success(_):
                            self?.animatePwArea()
                            self?.emailTextField.setIndicatorLabel(text: "사용가능한 이메일입니다.", correct: true)
                            self?.setNextBtnStyle(.incorrect) // 비밀번호 확인 될 때 까지 회색유지
                            self?.isEmail = true // 중복 검사 완료
                        
                        case .requestErr(let msg):
                            if let _ = msg as? String {
                                self?.emailTextField.setIndicatorLabel(text: "이미 등록된 이메일입니다.", correct: false)
                                self?.isEmail = false /// 중복 검사 불통과
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
    }
    
    // 비밀번호 표시 버튼 UI처리 로직
    private func reversalEyeBtn() {
        pwTextField.changeSecureMode()
        pwReTextField.changeSecureMode()
        let imgName = pwTextField.textfield.isSecureTextEntry ? "eyeOff" : "eye"
        firstEyeBtn.setImage(UIImage(named: imgName), for: .normal)
        secEyeBtn.setImage(UIImage(named: imgName), for: .normal)
    }
    
    // MARK: Etc
    
    private func textFeildDelegate(){
        emailTextField.textfield.delegate = self
        pwTextField.textfield.delegate = self
        pwReTextField.textfield.delegate = self
    }
    
    private func setInvisible(alpha: CGFloat) {
        typePasswordLabel.alpha = alpha
        pwTextField.alpha = alpha
        pwReTextField.alpha = alpha
    }
    
    // 비밀번호 입력부 등장 애니메이션
    private func animatePwArea(){
        UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: { [weak self] in
            self?.emailTextField.textfield.textColor = .textGrey
            self?.emailTextField.textfield.isEnabled = false
        }, completion: { _ in
            UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: { [weak self] in
                self?.setInvisible(alpha: 1)
                self?.typePasswordLabel.transform = CGAffineTransform(translationX: 0, y: -10)
                self?.pwTextField.transform = CGAffineTransform(translationX: 0, y: -10)
                self?.pwReTextField.transform = CGAffineTransform(translationX: 0, y: -10)
            })
        })
    }
    
    private func setNextBtnStyle(_ state: ButtonState) {
        switch state {
        case .correct:
            nextBtn.changeColors(bgColor: .seaweed, textColor: .white)
        case .incorrect:
            nextBtn.changeColors(bgColor: .inputGrey, textColor: .textGrey)
        }
    }
}

// MARK: Protocols
extension SignUpAccountVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField.textfield {
            let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluate(with: textField.text){
                emailTextField.setIndicatorLabel(text: "사용할 수 없는 형식입니다.", correct: false)
                setNextBtnStyle(.incorrect)
                isPossibleEmail = false
            }else{
                emailTextField.setIndicatorLabel(text: "사용가능한 이메일 형식입니다.", correct: true)
                setNextBtnStyle(.correct)
                isPossibleEmail = true
            }
        }
        // 1번 텍스트 필드
        else if textField == pwTextField.textfield {
            // 비밀번호가 영문 ,숫자,특수문자 포함 8글자인지
            let passRegEx = "^(?=.*[a-z])(?=.*[0-9])(?=.*[\\[\\]~!@#$%^&*()=+{}:?,<>/._-]).{8,}$"
            let passTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
            if !passTest.evaluate(with: textField.text){
                pwReTextField.setIndicatorLabel(text: "사용하실 수 없는 비밀번호 형식입니다.", correct: false)
                isPossiblePw = false
            } else {
                pwReTextField.setIndicatorLabel(text: "사용가능한 비밀번호입니다.", correct: true)
                isPossiblePw = true
                // 1번,2번 다 입력했는데 1번이 의도치 않게 오타나서 1번을 2번과 일치하게 바꾸면
                // 1번 텍스트 필드에서도 일치 검사를 해야하는 상황이 있음
                if textField.text == pwReTextField.textfield.text {
                    pwReTextField.setIndicatorLabel(text: "비밀번호가 일치합니다.", correct: true)
                    setNextBtnStyle(.correct)
                    isCorrectPw = true
                } else {
                    pwReTextField.setIndicatorLabel(text: "비밀번호가 일치하지 않습니다.", correct: false)
                    setNextBtnStyle(.incorrect)
                    isCorrectPw = false
                }
            }
        }
        // 2번 텍스트 필드
        else if textField == pwReTextField.textfield {
            // 형식을 통과했으며, 비밀번호가 일치하는지
            if isPossiblePw {
                if pwTextField.textfield.text == textField.text {
                    pwReTextField.setIndicatorLabel(text: "비밀번호가 일치합니다.", correct: true)
                    setNextBtnStyle(.correct)
                    isCorrectPw = true
                }else{
                    pwReTextField.setIndicatorLabel(text: "비밀번호가 일치하지 않습니다.", correct: false)
                    setNextBtnStyle(.incorrect)
                    isCorrectPw = false
                }
            }
        }
    }
    
    /// Return 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
