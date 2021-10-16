//
//  SignUpTextField.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/10/09.
//

import UIKit
import SnapKit

/**
 - Description:
 Cherish에서 자주 사용되는 TextField를 커스텀해놓았습니다.
 회원가입이나 식물 등록 뷰에서 많이 쓰이고있어요
 
 - Note:
 [Default Setting]
 내부 인셋 4방향 10
 radius 8.adjusted
 배경색 rgb 245 245 245
 글씨 색상 .black
 자간 -0.7
 폰트 NotoSansRegular 16.adjusted
 
 - setPlaceholder: placeholder 설정
 - setInset: 내부 inset 설정
 */
class CherishTextField: UITextField {
    private var insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var textDelegate : CherishTextFieldDelegate?
    
    init() {
        super.init(frame: .zero)
        setDefaultStyle()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setDefaultStyle()
    }
    
    // placeholder position with inset
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: insets))
    }
    
    // text position with inset
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds.inset(by: insets))
    }
    
    private func setDefaultStyle() {
        self.makeRounded(cornerRadius: 8.adjusted)
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.backgroundColor = .mypageBackgroundGrey
        self.font = UIFont.notoRegular(size: 16.adjusted)
        self.textColor = .black
        self.setCharacterSpacing(-0.7)
        self.addTarget(self, action: #selector(changeTextField), for: .editingChanged)
    }
    
    // MARK: Textfield Actions
    @objc
    func changeTextField() {
        textDelegate?.checkContentsForm(textField: self)
    }
    
    // MARK: Public Methods
    
    func setPlaceholder(placeholder: String) {
        self.placeholder = placeholder
    }
    
    func setInset(inset: UIEdgeInsets) {
        self.insets = inset
    }
}

protocol CherishTextFieldDelegate: UITextFieldDelegate {
    func checkContentsForm(textField: UITextField)
}
