//
//  SignUpNicknameVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/16.
//

import UIKit

class SignUpNicknameVC: UIViewController {

    @IBOutlet weak var nickNameTextField: UITextField!{
        didSet{
            nickNameTextField.makeRounded(cornerRadius: 8)
            nickNameTextField.backgroundColor = .inputGrey
        }
    }
    @IBOutlet weak var nickNameCheckLabel: CustomLabel!
    @IBOutlet weak var privacyPolicyBtn: UIButton!
    @IBOutlet weak var termOfServiceBtn: UIButton!
    @IBOutlet weak var startCherishBtn: UIButton!{
        didSet{
            startCherishBtn.makeRounded(cornerRadius: 25.0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func blankAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func startCherish(_ sender: Any) {
        if nickNameTextField.text?.count == 0 {
            blankAlert(title: "Cherish", message: "닉네임을 입력해주세요!")
        }
    }
}
