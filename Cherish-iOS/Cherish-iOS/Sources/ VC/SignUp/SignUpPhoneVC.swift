//
//  SignUpPhoneVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/15.
//

import UIKit
import MessageUI

class SignUpPhoneVC: UIViewController {
    //MARK: -변수 선언부
    var forSending = ["",""]

    //MARK: -@IBOutlet
    @IBOutlet weak var phoneTextField: UITextField!{
        didSet{
            phoneTextField.makeRounded(cornerRadius: 8)
            phoneTextField.addLeftPadding()
            phoneTextField.backgroundColor = .inputGrey
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
    @IBOutlet weak var typingMessageTextField: UITextField!{
        didSet{
            typingMessageTextField.makeRounded(cornerRadius: 8)
            typingMessageTextField.addLeftPadding()
            typingMessageTextField.backgroundColor = .inputGrey
        }
    }
    @IBOutlet weak var resendMessageBtn: UIButton!{
        didSet{
            resendMessageBtn.makeRounded(cornerRadius: 8)
            resendMessageBtn.layer.borderColor = UIColor.textGrey.cgColor
            resendMessageBtn.layer.borderWidth  = 1.0
        }
    }
    @IBOutlet weak var nextBtn: UIButton!{
        didSet{
            nextBtn.makeRounded(cornerRadius: 25.0)
            nextBtn.backgroundColor = .inputGrey
        }
    }
    @IBOutlet weak var beforeImageView: UIImageView!
    @IBOutlet weak var afterImageView: UIImageView!
    
    //MARK: -viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(forSending)
        initialSetting(status: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //self.forChangeImageView.image = UIImage(named: "joinCircleUnselected")
        UIView.animate(withDuration: 1.0, animations: {
            self.beforeImageView.image = UIImage(named: "joinCircleUnselected")
        },completion: {finished in
            UIView.animate(withDuration: 1.0, animations: {
                self.afterImageView.image = UIImage(named: "joinCircleSelected")
            })
        })
    }
    
    ///화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: -Personal Func
    func initialSetting(status: Bool){
        pleaseTypingLabel.isHidden = status
        typingMessageTextField.isHidden = status
        resendMessageBtn.isHidden = status
    }
        
    func greenBtn(){
        nextBtn.backgroundColor = .seaweed
        nextBtn.setTitleColor(.white, for: .normal)
    }

    //MARK: -@IBAction
    @IBAction func receiveMessage(_ sender: Any) {
        requestMessageBtn.isHidden = true
        initialSetting(status: false)
        greenBtn()
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextAction(_ sender: Any) {
        // 인증완료 되었으면 넘기기
        if let vc = self.storyboard?.instantiateViewController(identifier: "SignUpGenderVC") as? SignUpGenderVC {
            vc.forSending[0] = forSending[0]
            vc.forSending[1] = forSending[1]
            vc.forSending[2] = phoneTextField.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
