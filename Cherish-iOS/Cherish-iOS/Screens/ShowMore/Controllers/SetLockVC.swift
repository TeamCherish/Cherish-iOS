//
//  SetLockVC.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/11/08.
//

import UIKit
import SnapKit
import Then

enum Mode {
    case lock, unlock
}

final class SetLockVC: BaseController {
    
    // MARK: UI Components
    
    private lazy var naviBar = BackNaviView().then {
        $0.setTitleLabel(title: "비밀번호 설정")
        $0.backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private lazy var indicatorLabel = UILabel().then {
        $0.setLabel(text: "새로운 비밀번호를 입력해주세요.", size: 16)
    }
    
    private lazy var leafImageViews: [LeafModel] = [
        LeafModel(isActivated: false),
        LeafModel(isActivated: false),
        LeafModel(isActivated: false),
        LeafModel(isActivated: false),
    ]
    
    private lazy var leafStackView = UIStackView().then {
        $0.setStackView(arrangedSubviews: leafImageViews.map {$0.imgView}, axis: .horizontal,
                        spacing: 19, alignment: .fill, distribution: .equalSpacing)
    }
    
    private lazy var numbersBtns: [NumPadBtn] = [
        NumPadBtn(title: "1"), NumPadBtn(title: "2"), NumPadBtn(title: "3"),
        NumPadBtn(title: "4"), NumPadBtn(title: "5"), NumPadBtn(title: "6"),
        NumPadBtn(title: "7"), NumPadBtn(title: "8"), NumPadBtn(title: "9"),
        NumPadBtn(title: ""), NumPadBtn(title: "0"), NumPadBtn(title: nil)
    ]
    
    private lazy var firstLinePad = UIStackView().then {
        $0.setStackView(arrangedSubviews: [numbersBtns[0], numbersBtns[1], numbersBtns[2]], axis: .horizontal, distribution: .fillProportionally)
    }
    
    private lazy var secLinePad = UIStackView().then {
        $0.setStackView(arrangedSubviews: [numbersBtns[3], numbersBtns[4], numbersBtns[5]], axis: .horizontal, distribution: .fillProportionally)
    }
    
    private lazy var thdLinePad = UIStackView().then {
        $0.setStackView(arrangedSubviews: [numbersBtns[6], numbersBtns[7], numbersBtns[8]], axis: .horizontal, distribution: .fillProportionally)
    }
    
    private lazy var lastLinePad = UIStackView().then {
        $0.setStackView(arrangedSubviews: [numbersBtns[9], numbersBtns[10], numbersBtns[11]], axis: .horizontal, distribution: .fillEqually)
    }
    
    private lazy var keyPadStack = UIStackView().then {
        $0.setStackView(arrangedSubviews: [firstLinePad, secLinePad, thdLinePad, lastLinePad], axis: .vertical, distribution: .fillEqually)
    }
    
    private lazy var cautionLabel = UILabel().then {
        $0.setLabel(text: "암호를 분실했을 경우 앱을 삭제하고 재설치해야 됩니다.", color: .pinkSub, size: 12)
    }
    
    private lazy var completeBtn = CherishBtn().then {
        $0.setTitleWithStyle(title: "설정완료", size: 16, weight: .medium)
        $0.press { [weak self] in
            if self?.password.count == 4 && self?.doubleCheck == true {
                UserDefaults.standard.set(self?.password, forKey: "AppLockPW")
                self?.feedback?.notificationOccurred(.success)
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.feedback?.notificationOccurred(.warning)
            }
        }
    }
    
    // MARK: Variables
    
    private var password = [Int]()
    private var passwordForCheck = [Int]()
    private var doubleCheck = false
    var modeSelect: Mode = .lock
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        self.setDelegate()
        self.defineLockModeLayout(mode: modeSelect)
    }
}

// MARK: Extension

extension SetLockVC {
    
    private func setDelegate() {
        for btn in numbersBtns {
            btn.numPadDeleagate = self
        }
    }
    
    // MARK: Layout
    
    private func setLayout() {
        setNaviLayout()
        setIndicatorArea()
        setKeyPadArea()
        setBottomArea()
    }
    
    private func defineLockModeLayout(mode: Mode) {
        if mode == .unlock {
            self.naviBar.isHidden = true
            self.cautionLabel.isHidden = true
            self.completeBtn.isHidden = true
            self.indicatorLabel.text = "비밀번호 입력"
        }
    }
    
    private func setNaviLayout() {
        self.view.add(naviBar) {
            $0.snp.makeConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(48.adjustedH)
            }
        }
    }
    
    private func setIndicatorArea() {
        self.view.adds([indicatorLabel, leafStackView]) {
            $0[0].sizeToFit()
            $0[0].setContentHuggingPriority(.required, for: .vertical)
            $0[0].snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.naviBar.snp.bottom).offset(98.adjustedH)
            }
            
            $0[1].snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.indicatorLabel.snp.bottom).offset(44.adjustedH)
            }
        }
    }
    
    private func setKeyPadArea() {
        self.view.add(keyPadStack) {
            $0.setContentHuggingPriority(.required, for: .vertical)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.leafStackView.snp.bottom).offset(50.adjustedH)
                $0.width.equalTo(UIScreen.main.bounds.width-32)
            }
        }
    }
    
    private func setBottomArea() {
        self.view.adds([cautionLabel, completeBtn]) {
            $0[0].setContentHuggingPriority(.required, for: .vertical)
            $0[0].snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.keyPadStack.snp.bottom).offset(40)
            }
            
            $0[1].snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.cautionLabel.snp.bottom).offset(14)
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().inset(16)
                $0.height.equalTo(50.adjusted)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(45)
            }
        }
    }
}

// MARK: Password Logic

extension SetLockVC: NumPadDelegate {
    func receiveAction(number: Int?) {
        // MARK: Input Logic
        if let number = number {
            if password.count < 4 {
                password.append(number)
                leafImageViews[password.count-1].isActivated = true
            }
        } else {
            if password.count > 0 {
                leafImageViews[password.count-1].isActivated = false
                password.removeLast()
            }
            completeBtn.isActivated = false
        }
        print(password)
        
        // MARK: Complete Logic
        switch modeSelect {
        case .unlock:
            guard let pw = UserDefaults.standard.value(forKey: "AppLockPW") as? [Int] else { return }
            if password.count == 4 {
                if password == pw {
                    self.feedback?.notificationOccurred(.success)
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                        self.view.removeFromSuperview()
                    }
                } else {
                    self.makeVibrate(degree: .medium)
                    self.leafStackView.shake()
                    self.password = []
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                        (0..<4).forEach { self.leafImageViews[$0].isActivated = false }
                    }
                }
            }
        default:
            doubleCheck = password == passwordForCheck ? true : false
            if password.count == 4 && !doubleCheck && passwordForCheck.isEmpty {
                passwordForCheck = password
                password = []
                indicatorLabel.text = "확인을 위해 한 번 더 입력해주세요"
                DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
                    (0..<4).forEach { self.leafImageViews[$0].isActivated = false }
                }
            }
            completeBtn.isActivated = password.count == 4 && doubleCheck ? true : false
        }
    }
}
