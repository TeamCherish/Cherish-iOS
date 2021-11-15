//
//  UIViewController+Extension.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/06/08.
//

import UIKit

extension UIViewController {
    /**
     - Description: 화면 터치시 작성 종료
     */
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /**
     - Description: 화면 터치시 키보드 내리는 Extension
     */
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /**
     - Description: Alert
     */
    func makeAlertWithCancel(title : String, message : String,
                             okTitle: String = "확인", okStyle: UIAlertAction.Style = .default,
                             cancelTitle: String = "취소",
                             okAction : ((UIAlertAction) -> Void)?, cancelAction : ((UIAlertAction) -> Void)? = nil,
                             completion : (() -> Void)? = nil) {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: okStyle, handler: okAction)
        alertViewController.addAction(okAction)
        
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelAction)
        alertViewController.addAction(cancelAction)
        
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    
    func makeAlert(title : String, message : String? = nil,
                   okTitle: String = "확인", okAction : ((UIAlertAction) -> Void)? = nil,
                   completion : (() -> Void)? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: okAction)
        alertViewController.addAction(okAction)
        
        
        self.present(alertViewController, animated: true, completion: completion)
    }
}
