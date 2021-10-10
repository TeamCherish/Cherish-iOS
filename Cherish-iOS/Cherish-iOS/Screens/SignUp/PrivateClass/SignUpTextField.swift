//
//  SignUpTextField.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/10/09.
//

import UIKit
import SnapKit

final class SignUpTextField: UIView {
    private (set) lazy var indicatorLabel = UILabel()
    private (set) lazy var textfield = CherishTextField()
    
    init() {
        super.init(frame: .zero)
        setDefaultLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDefaultLayout() {
        self.adds([textfield,indicatorLabel]) {
            $0[0].snp.makeConstraints {
                $0.top.left.right.equalToSuperview()
                $0.height.equalTo(44.adjusted)
            }
            
            $0[1].snp.makeConstraints {
                $0.top.equalTo(self.textfield.snp.bottom)
                $0.right.equalTo(self.textfield)
            }
        }
    }
    
    func setPlaceholder(placeholder: String) {
        textfield.setPlaceholder(placeholder: placeholder)
    }
    
    func setIndicatorLabel(text: String, correct: Bool) {
        indicatorLabel.setLabel(text: text,
                                color: correct ? .seaweed : .pinkSub,
                                size: 12.adjusted,
                                weight: .medium)
        
        if !correct {
            textfield.shake()
        }
    }
    
    func changeSecureMode() {
        self.textfield.isSecureTextEntry = !self.textfield.isSecureTextEntry
    }
}
