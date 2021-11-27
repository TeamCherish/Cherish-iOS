//
//  NavigationController.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/11/27.
//

import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    /// Custom back buttons disable the interactive pop animation
    /// To enable it back we set the recognizer to `self`
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
}
