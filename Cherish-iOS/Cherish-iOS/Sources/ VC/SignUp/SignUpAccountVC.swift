//
//  SignUpAccountVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/15.
//

import UIKit

class SignUpAccountVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.addLeftPadding()
            emailTextField.backgroundColor = .inputGrey
        }
    }
    @IBOutlet weak var emailCheckBtn: UIButton!{
        didSet{
            emailCheckBtn.makeRounded(cornerRadius: 25.0)
            emailCheckBtn.backgroundColor = .inputGrey
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.addLeftPadding()
            passwordTextField.backgroundColor = .inputGrey
        }
    }
    @IBOutlet weak var passwordCheckTextField: UITextField!{
        didSet{
            passwordCheckTextField.addLeftPadding()
            passwordCheckTextField.backgroundColor = .inputGrey
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
