//
//  BaseController.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/11/08.
//

import UIKit

class BaseController: UIViewController {
    private (set) var feedback: UINotificationFeedbackGenerator?
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
        self.setFeebBackGenerator()
    }
    
    private func setFeebBackGenerator() {
        self.feedback = UINotificationFeedbackGenerator()
        self.feedback?.prepare()
    }
}
