//
//  PopUpContact.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/03.
//

import UIKit
import MessageUI
import CallKit

class PopUpContactVC: UIViewController {
    let callObserver = CXCallObserver()
    var didDetectOutgoingCall = false
    
    @IBOutlet weak var popupContactView: UIView!{
        didSet{
            popupContactView.makeRounded(cornerRadius: 20.0)
        }
    }
    @IBOutlet weak var contactNameLabel: CustomLabel!{
        didSet{
            contactNameLabel.textColor = .black
        }
    }
    @IBOutlet weak var contactConversationLabel: CustomLabel!{
        didSet{
            contactConversationLabel.textColor = .black
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Call Material
    func showCallAlert() {
        guard let url = NSURL(string: "tel://" + "01068788309"),
            UIApplication.shared.canOpenURL(url as URL) else {
                return
        }

        callObserver.setDelegate(self, queue: nil)

        didDetectOutgoingCall = false

        //we only want to add the observer after the alert is displayed,
        //that's why we're using asyncAfter(deadline:)
        UIApplication.shared.open(url as URL, options: [:]) { [weak self] success in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self?.addNotifObserver()
                }
            }
        }
    }
    
    func addNotifObserver() {
        let selector = #selector(appDidBecomeActive)
        let notifName = UIApplication.didBecomeActiveNotification
        NotificationCenter.default.addObserver(self, selector: selector, name: notifName, object: nil)
    }
    
    @objc func appDidBecomeActive() {
        //if callObserver(_:callChanged:) doesn't get called after a certain time,
        //the call dialog was not shown - so the Cancel button was pressed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            if !(self?.didDetectOutgoingCall ?? true) {
                print("Cancel button pressed")
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func calling(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        showCallAlert()
        
    }
    @IBAction func kakoTalking(_ sender: Any) {
        let kakaoTalk = "kakaotalk://"
        let kakaoTalkURL = NSURL(string: kakaoTalk)
        guard let pvc = self.presentingViewController else {return}
        
        if UIApplication.shared.canOpenURL(kakaoTalkURL! as URL) {
            /// 연락 수단 선택 창 dismiss
            self.dismiss(animated: true){
                UIApplication.shared.open(kakaoTalkURL! as URL){_ in
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Review", bundle: nil)
                    if let vc = storyBoard.instantiateViewController(withIdentifier: "ReviewVC") as? ReviewVC{
                        vc.modalPresentationStyle = .fullScreen
                        pvc.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
        else {
            print("No kakaostory installed.")
        }
    }
    @IBAction func messaging(_ sender: Any) {
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        if MFMessageComposeViewController.canSendText(){
            messageComposer.recipients = ["01068788309"]
            messageComposer.body = ""
            messageComposer.modalPresentationStyle = .currentContext
            //messageComposer.modalTransitionStyle = .crossDissolve
            self.present(messageComposer, animated: true)
        }
    }
    
}

//MARK: -Protocol Extension
extension PopUpContactVC: CXCallObserverDelegate{
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.isOutgoing && !didDetectOutgoingCall {
            didDetectOutgoingCall = true
            let storyBoard: UIStoryboard = UIStoryboard(name: "Review", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "ReviewVC") as? ReviewVC{
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            print("Call button pressed")
        }
    }
}

extension PopUpContactVC: MFMessageComposeViewControllerDelegate{
    /// 메시지 전송 결과
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case MessageComposeResult.sent:
            print("전송 완료")
            break
        case MessageComposeResult.cancelled:
            print("취소")
            break
        case MessageComposeResult.failed:
            print("전송 실패")
            break
        @unknown default:
            fatalError()
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

