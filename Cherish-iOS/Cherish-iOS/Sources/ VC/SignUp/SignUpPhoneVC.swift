//
//  SignUpPhoneVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/15.
//

import UIKit

class SignUpPhoneVC: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!{
        didSet{
            phoneTextField.makeRounded(cornerRadius: 8)
            phoneTextField.addLeftPadding()
        }
    }
    @IBOutlet weak var requestMessageBtn: UIButton!{
        didSet{
            requestMessageBtn.makeRounded(cornerRadius: 8)
            requestMessageBtn.layer.borderColor = UIColor.textGrey.cgColor
            requestMessageBtn.layer.borderWidth  = 1.0
        }
    }
    @IBOutlet weak var pleaseTypingLabel: CustomLabel!
    @IBOutlet weak var typingMessageTextField: UITextField!
    @IBOutlet weak var resendMessageBtn: UIButton!{
        didSet{
            resendMessageBtn.makeRounded(cornerRadius: 8)
            resendMessageBtn.layer.borderColor = UIColor.textGrey.cgColor
            resendMessageBtn.layer.borderWidth  = 1.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetting(status: true)
    }
    
    func initialSetting(status: Bool){
        pleaseTypingLabel.isHidden = status
        typingMessageTextField.isHidden = status
        resendMessageBtn.isHidden = status
    }


    @IBAction func receiveMessage(_ sender: Any) {
        requestMessageBtn.isHidden = true
        initialSetting(status: false)
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
