//
//  SignUpDotStackView.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/10/10.
//

import UIKit

/**
 - Description: 회원가입 뷰에서 위에 동그라미들 스택뷰로 재사용하기 위해 커스텀
 */
class SignUpDotStackView: UIStackView {
    
    init(dotNum: Int, greenDotIdx: Int) {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.distribution = .equalSpacing
        self.alignment = .center
        self.spacing = 9
        
        for i in 0..<dotNum {
            let dot = UIImageView().then {
                $0.image = UIImage(named: i == greenDotIdx ? "joinCircleSelected" : "joinCircleUnselected")
            }
            self.addArrangedSubview(dot)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
