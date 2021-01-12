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
    var keyword = [String]()
    let callObserver = CXCallObserver()
    var didDetectOutgoingCall = false
    var total: CGFloat? = 0
    
    //MARK: -@IBOutlet
    @IBOutlet weak var popupContactView: UIView!{
        didSet{
            popupContactView.makeRounded(cornerRadius: 20.0)
        }
    }
    @IBOutlet weak var contactNameLabel: CustomLabel! ///남쿵둥이와는
    @IBOutlet weak var keywordShowCollectionView: UICollectionView!{
        didSet{
            self.keywordShowCollectionView.register(KeywordCVC.nib(), forCellWithReuseIdentifier: KeywordCVC.identifier)
            keywordShowCollectionView.delegate = self
            keywordShowCollectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecentKeyword()
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
    
    // 최근 키워드 받아오기 및 연락 상대 이름에 따라 Label 변경
    func getRecentKeyword() {
        RecentKeywordService.shared.recentKeyword(id: 5) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let checkData = data as? RecentKeywordData {
                    contactNameLabel.text = checkData.nickname
                    keyword.append(checkData.water.keyword1)
                    keyword.append(checkData.water.keyword2)
                    keyword.append(checkData.water.keyword3)
                    DispatchQueue.main.async {
                            keywordShowCollectionView.reloadData()
                    }
                }
                
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    //MARK: -@IBAction
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func calling(_ sender: Any) {
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
            self.present(messageComposer, animated: true)
        }
    }
    
}

//MARK: -Protocol Extension
/// 1
extension PopUpContactVC: CXCallObserverDelegate{
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        /// 통화를 하게 되면
        if call.isOutgoing && !didDetectOutgoingCall {
            didDetectOutgoingCall = true
            
            guard let pvc = self.presentingViewController else {return}
            self.dismiss(animated: true){
                let storyBoard: UIStoryboard = UIStoryboard(name: "Review", bundle: nil)
                if let vc = storyBoard.instantiateViewController(withIdentifier: "ReviewVC") as? ReviewVC{
                    vc.modalPresentationStyle = .fullScreen
                    pvc.present(vc, animated: true, completion: nil)
                }
            }
            print("Call button pressed")
        }
    }
}

/// 2
extension PopUpContactVC: MFMessageComposeViewControllerDelegate{
    /// 메시지 전송 결과
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case MessageComposeResult.sent:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Review", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "ReviewVC") as? ReviewVC{
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
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

/// 3
extension PopUpContactVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyword.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCVC.identifier, for: indexPath) as? KeywordCVC else{
            return UICollectionViewCell()
        }
        cell.keywordLabel.text = keyword[indexPath.row]
        
        return cell
    }
    
    //MARK: - Cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let label = UILabel(frame: CGRect.zero)
        label.text = keyword[indexPath.row]
        label.sizeToFit()
        total? += label.frame.width + 10
        return CGSize(width: label.frame.width+10, height: collectionView.frame.height)
        
        
    }
    
    //MARK: - Cell간의 좌우간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 8
    }
    
    //MARK: - 마진
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        // Cell 가운데 정렬
        let edgeInsets = (keywordShowCollectionView.frame.width  - (CGFloat(total ?? 0)) - (CGFloat(keyword.count-1) * 9)) / 2
        
        return UIEdgeInsets(top: 0, left: CGFloat(edgeInsets), bottom: 0, right: 0);
        
    }
}
