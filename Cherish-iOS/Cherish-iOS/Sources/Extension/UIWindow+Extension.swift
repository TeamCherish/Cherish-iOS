//
//  UIWindow+Extension.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/03/11.
//

import Foundation
import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
