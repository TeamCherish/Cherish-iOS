//
//  NewShowMoreVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/02/23.
//

import UIKit
import SafariServices
import MessageUI

class NewShowMoreVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var showMoreTV: UITableView!
    @IBOutlet var userNicknameLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!
    
    var infoTitleArray:[String] = ["About Cherish", "개인정보처리방침", "서비스이용약관", "1대1 문의하기"]
    var logInfoTitleArray:[String] = ["로그아웃", "회원탈퇴"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setUserInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUserInfo()
    }
    
    // my selector that was defined above
    @objc func willEnterForeground() {
        showMoreTV.reloadData()
    }
    
    func setDelegates() {
        showMoreTV.delegate = self
        showMoreTV.dataSource = self
        showMoreTV.separatorStyle = .none
    }
    
    func setUserInfo() {
        userNicknameLabel.text = UserDefaults.standard.string(forKey: "userNickname")
        userEmailLabel.text = UserDefaults.standard.string(forKey: "userEmail")
        userNicknameLabel.sizeToFit()
        userEmailLabel.sizeToFit()
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpToNicknameChangeVC(_ sender: UIButton) {
        let NicknameChangeVC = self.storyboard?.instantiateViewController(identifier: "NicknameChangeVC") as! NicknameChangeVC
        self.navigationController?.pushViewController(NicknameChangeVC, animated: true)
    }
    
    @IBAction func toggleAlarmSwitch(_ sender: UISwitch) {
        //Off였던 토글값을 On으로 바꿨을 때 작동
        //현재 퍼미션 상태는 당연히 알림이 거부된 상태겠죠? 원상태가 토글 off였으니!
        //이 때의 액션은 사용자가 거부했던 알림을 다시 켜고 싶을 때 발생하는 것이므로,
        //case .denied (즉, 현상태가 denied) 에다가 url연결을 시켜줄게요!
        if sender.isOn {
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { permission in
                switch permission.authorizationStatus  {
                case .authorized:
                    print("User granted permission for notification")
                case .denied:
                    DispatchQueue.main.async { [self] in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                    print("User denied notification permission")
                case .notDetermined:
                    print("Notification permission haven't been asked yet")
                case .provisional:
                    // @available(iOS 12.0, *)
                    print("The application is authorized to post non-interruptive user notifications.")
                case .ephemeral:
                    // @available(iOS 14.0, *)
                    print("The application is temporarily authorized to post notifications. Only available to app clips.")
                @unknown default:
                    print("Unknow Status")
                }
            })
        }
        //On이였던 토글값을 Off으로 바꿨을 때 작동
        //현재 퍼미션 상태는 당연히 알림이 허용된 상태겠죠? 원상태가 토글 On이였으니!
        //이 때의 액션은 사용자가 허용했던 알림을 다시 거부하고 싶을 때 발생하는 것이므로,
        //case .authorized (즉, 현상태가 authorized) 에다가 url연결을 시켜줄게요!
        else {
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { permission in
                switch permission.authorizationStatus  {
                case .authorized:
                    DispatchQueue.main.async {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        
                    }
                    print("User granted permission for notification")
                case .denied:
                    print("User denied notification permission")
                case .notDetermined:
                    print("Notification permission haven't been asked yet")
                case .provisional:
                    // @available(iOS 12.0, *)
                    print("The application is authorized to post non-interruptive user notifications.")
                case .ephemeral:
                    // @available(iOS 14.0, *)
                    print("The application is temporarily authorized to post notifications. Only available to app clips.")
                @unknown default:
                    print("Unknow Status")
                }
            })
        }
    }
    
}

extension NewShowMoreVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return infoTitleArray.count
        }
        else if section == 1 {
            return 1
        }
        else {
            return logInfoTitleArray.count
        }
        
    }
    
    //MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowMoreFirstTVCell") as! ShowMoreFirstTVCell
            cell.titleLabel.text = infoTitleArray[indexPath.row]
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowMoreSecondTVCell") as! ShowMoreSecondTVCell
            cell.titleLabel.text = "물주기 알림"
            cell.selectionStyle = .none
            
            let current = UNUserNotificationCenter.current()
            
            //현재 푸시알림 승인상태에 따른 분기처리
            current.getNotificationSettings(completionHandler: {
                (settings) in
                if settings.authorizationStatus == .notDetermined {
                    DispatchQueue.main.async {
                        cell.pushAlarmSwitch.isOn = false
                        print("notDetermined")
                    }
                } else if settings.authorizationStatus == .denied {
                    DispatchQueue.main.async {
                        cell.pushAlarmSwitch.isOn = false
                        print("denied")
                    }
                } else if settings.authorizationStatus == .authorized {
                    DispatchQueue.main.async {
                        cell.pushAlarmSwitch.isOn = true
                        print("authorized")
                    }
                }
            })
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowMoreThirdTVCell") as! ShowMoreThirdTVCell
            cell.titleLabel.text = logInfoTitleArray[indexPath.row]
            return cell
        }
    }
    
    //MARK: - heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 48
        }else if indexPath.section == 1 {
            return 57
        }else{
            return 46
        }
    }
    
    //MARK: - viewForHeaderInSection
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView()
        sectionHeader.backgroundColor = .inputGrey
        return sectionHeader
    }
    
    //MARK: - heightForHeaderInSection
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        else {
            return 5
        }
    }
    
    //MARK: - viewForFooterInSection
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionFooter = UIView()
        sectionFooter.backgroundColor = .clear
        return sectionFooter
    }
    
    //MARK: - heightForFooterInSection
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    //MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //About Cherish
            if indexPath.row == 0 {
                print("section 0, row 0")
            }
            //개인정보처리방침
            else if indexPath.row == 1 {
                let url = NSURL(string: "https://www.notion.so/Cherish-2d35c1bffa2f4d49943db302d76e3cac")
                let safari: SFSafariViewController = SFSafariViewController(url: url as! URL)
                self.present(safari, animated: true, completion: nil)
            }
            //서비스이용약관
            else if indexPath.row == 2 {
                let url = NSURL(string: "https://www.notion.so/Cherish-d96f88172ffa4d80b257665849bddc65")
                let safari: SFSafariViewController = SFSafariViewController(url: url as! URL)
                self.present(safari, animated: true, completion: nil)
            }
            //1:1 문의하기
            else {
                if MFMailComposeViewController.canSendMail() {
                    
                    let compseVC = MFMailComposeViewController()
                    compseVC.mailComposeDelegate = self
                    
                    compseVC.setToRecipients(["Co.Cherishteam@gmail.com"])
                    compseVC.setSubject("체리쉬 문의")
                    compseVC.setMessageBody("1. 문의 유형(문의, 버그 제보, 기타) : \n 2. 회원 닉네임(필요시 기입) : \n 3. 문의 내용 : \n \n \n 문의하신 사항은 체리쉬팀이 신속하게 처리하겠습니다. 감사합니다 :)", isHTML: false)
                    
                    self.present(compseVC, animated: true, completion: nil)
                    
                }
                else {
                    self.showSendMailErrorAlert()
                }
                
            }
        }
        else if indexPath.section == 2 {
            //로그아웃
            if indexPath.row == 0 {
                let logoutAlert = UIAlertController(title: "로그아웃", message: "정말로 로그아웃 하시겠습니까?", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default) { [self]
                    (action) in
                    
                    //로그아웃하기 위해 자동로그인을 위해 사용되었던
                    //UserDefualts에 저장된 값들을 삭제해준다
                    UserDefaults.standard.removeObject(forKey: "loginEmail")
                    UserDefaults.standard.removeObject(forKey: "loginPw")
                    UserDefaults.standard.removeObject(forKey: "autoLogin")
                    
                    // 자동로그인 해제시 루트 컨트롤러를 로그인으로 설정
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let loginView: LoginNC = storyboard.instantiateViewController(withIdentifier: "LoginNC") as! LoginNC
                    UIApplication.shared.keyWindow?.rootViewController = loginView
                    
                }
                logoutAlert.addAction(confirmAction)
                self.present(logoutAlert, animated: true, completion: nil)
            }
            //회원탈퇴
            else {
                print("section 2, row 1")
            }
        }
    }
}
