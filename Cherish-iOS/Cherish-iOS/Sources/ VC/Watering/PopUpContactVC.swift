//
//  PopUpContact.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/03.
//

import UIKit
import MessageUI
import CallKit
import Alamofire

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
        guard let url = NSURL(string: "tel://" + UserDefaults.standard.string(forKey: "selectedFriendPhoneData")!),
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
        print(UserDefaults.standard.integer(forKey: "selectedFriendIdData"))
        RecentKeywordService.shared.recentKeyword(CherishId: UserDefaults.standard.integer(forKey: "selectedFriendIdData")) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                print(data)
                if let checkData = data as? RecentKeywordData {
                    UserDefaults.standard.set(checkData.nickname, forKey: "wateringNickName")
                    contactNameLabel.text = "\(checkData.nickname)"+"와/과"
                    if checkData.result.keyword1 != ""{
                        keyword.append(checkData.result.keyword1)
                    }
                    if checkData.result.keyword2 != ""{
                        keyword.append(checkData.result.keyword2)
                    }
                    if checkData.result.keyword3 != ""{
                        keyword.append(checkData.result.keyword3)
                    }
                    print(keyword)
                    keywordShowCollectionView.reloadData()
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
    
    func postPushReview(cherishIdx:Int) {
        PushReviewService.shared.postContact(cherishId:cherishIdx ) {
            (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                print(data)
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
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
                UIApplication.shared.open(kakaoTalkURL! as URL){ [self]_ in
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Review", bundle: nil)
                    if let vc = storyBoard.instantiateViewController(withIdentifier: "ReviewVC") as? ReviewVC{
                        vc.modalPresentationStyle = .fullScreen
                        pvc.present(vc, animated: true, completion: nil)
                    }
                    // 푸시알람기능을 위해 카톡 연결을 했음을 알려주는 서버 연결
                    postPushReview(cherishIdx: UserDefaults.standard.integer(forKey: "selectedFriendIdData"))
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
            messageComposer.recipients = [UserDefaults.standard.string(forKey: "selectedFriendPhoneData")!]
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
            
            // 푸시알람기능을 위해 전화연결을 했음을 알려주는 서버 연결
            postPushReview(cherishIdx: UserDefaults.standard.integer(forKey: "selectedFriendIdData"))
        }
    }
}

/// 2
extension PopUpContactVC: MFMessageComposeViewControllerDelegate{
    /// 메시지 전송 결과
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case MessageComposeResult.sent:
            guard let pvc = self.presentingViewController else {return}
            let storyBoard: UIStoryboard = UIStoryboard(name: "Review", bundle: nil)
            controller.dismiss(animated: true){
                self.dismiss(animated: true){
                    if let vc = storyBoard.instantiateViewController(withIdentifier: "ReviewVC") as? ReviewVC{
                        vc.modalPresentationStyle = .fullScreen
                        pvc.present(vc, animated: true, completion: nil)
                    }
                }
            }
            // 푸시알람기능을 위해 문자연결을 했음을 알려주는 서버 연결
            postPushReview(cherishIdx: UserDefaults.standard.integer(forKey: "selectedFriendIdData"))
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
        total? += label.frame.width+15
        return CGSize(width: label.frame.width+15, height: collectionView.frame.height)
    }

    //MARK: - Cell간의 좌우간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 7
    }

    //MARK: - 마진
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        // Cell 가운데 정렬
        let edgeInsets = (keywordShowCollectionView.frame.width  - (CGFloat(total ?? 0)) - (CGFloat(keyword.count-1) * 7)) / 2
        return UIEdgeInsets(top: 0, left: CGFloat(edgeInsets), bottom: 0, right: 0);
    }
}
