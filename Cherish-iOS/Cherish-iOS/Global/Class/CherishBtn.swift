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
        self.backgroundColor = .seaweed
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    // MARK: Public Methods
    /**
     UIButton+Extension 내 메서드 참고
     */
}
