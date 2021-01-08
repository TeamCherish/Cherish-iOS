//
//  UITextField+Extension.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/03.
//

import Foundation
import UIKit

extension UITextField{
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
}
