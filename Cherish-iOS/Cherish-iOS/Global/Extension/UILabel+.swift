//
//  UILabel+.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/10/10.
//

import UIKit

extension UILabel {
    
    /// 글씨의 오토레이아웃, 자간 -0.7이 기본으로 되어있는 메서드
    func setLabel(text: String, color: UIColor = .black, size: CGFloat, weight: FontWeight = .regular) {
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
        self.font = font
        self.textColor = color
        self.text = text
        self.setCharacterSpacing(-0.7)
    }
}
