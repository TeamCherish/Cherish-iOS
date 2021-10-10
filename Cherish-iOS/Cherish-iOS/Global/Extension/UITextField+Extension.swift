//
//  UITextField+Extension.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/03.
//

import UIKit

extension UITextField{
    /// Texfield를 진동온 것처럼 흔들리게 합니다.
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.3
        animation.values = [-5.0, 5.0, -5.0, 5.0 ,-2.0, 2.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    // FIXME: CherishTextField 사용으로 통일하면 어차피 내부 inset 적용할 수 있다 코드 통일되면 밑에 다 지울 것
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    func addRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 111, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
    func addDetailRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    func addSelectRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    func addLoginTextFieldLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    func addChangeNicknameTextFieldLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
