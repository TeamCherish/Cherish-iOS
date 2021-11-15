//
//  CherishBtn.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/10/09.
//

import UIKit

/**
 - Description:
 Cherish에서 자주 사용되는 bg: .seawead/ font: .white 컬러의 동그란 모양 버튼
 폰트는 NotoSansMedium: 16pt가 기본이고 이외에는 메서드를 통해 커스텀하여 사용
 
 - Note:
 - setButton: 버튼 기본 셋팅 변경
 - setTitle: 버튼 타이틀만 변경
 - changeColors: 버튼 배경색, 글씨색 변경
 */
class CherishBtn: UIButton {
    var isActivated: Bool = false {
        didSet {
            self.backgroundColor = self.isActivated ? activatedBgColor : normalBgColor
            self.setTitleColor(self.isActivated ? activatedFontColor : normalFontColor, for: .normal)
        }
    }
    
    private var normalBgColor: UIColor = .inputGrey
    private var normalFontColor: UIColor = .textGrey
    private var activatedBgColor: UIColor = .seaweed
    private var activatedFontColor: UIColor = .white
    
    init() {
        super.init(frame: .zero)
        setDefaultStyle()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setDefaultStyle()
    }
    
    private func setDefaultStyle() {
        self.makeRounded(cornerRadius: 25.adjusted)
        self.titleLabel?.setCharacterSpacing(-0.7)
        self.titleLabel?.font = .notoMedium(size: 16)
        self.backgroundColor = self.normalBgColor
        self.setTitleColor(self.normalFontColor, for: .normal)
    }
    
    // MARK: Public Methods
    /**
     UIButton+Extension 내 메서드 참고
     */
    func setBtnColors(normalBgColor: UIColor, normalFontColor: UIColor, activatedBgColor: UIColor, activatedFontColor: UIColor) {
        self.normalBgColor = normalBgColor
        self.normalFontColor = normalFontColor
        self.activatedBgColor = activatedBgColor
        self.activatedFontColor = activatedFontColor
    }
    
    /// 버튼 타이틀과 스타일 변경 폰트 사이즈 adjusted 적용
    func setTitleWithStyle(title: String, size: CGFloat, weight: FontWeight = .regular) {
        let font: UIFont
        
        switch weight {
        case .light:
            font = .notoLight(size: size.adjusted)
        case .regular:
            font = .notoRegular(size: size.adjusted)
        case .medium:
            font = .notoMedium(size: size.adjusted)
        case .bold:
            font = .notoBold(size: size.adjusted)
        }
        self.titleLabel?.font = font
        self.setTitle(title, for: .normal)
    }
}
