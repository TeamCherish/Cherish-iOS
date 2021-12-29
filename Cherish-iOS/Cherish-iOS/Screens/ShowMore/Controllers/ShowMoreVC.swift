//
//  ShowMoreVC.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/11/08.
//

import UIKit
import SnapKit
import Then
import SafariServices
import MessageUI

final class ShowMoreVC: BaseController {
    
    // MARK: UI
    
    private lazy var viewTitleLabel = UILabel().then {
        $0.setLabel(text: "더보기", size: 16, weight: .medium)
    }
    
    private lazy var userProfileImageView = UIImageView().then {
        $0.image = UIImage(named: "userImg")
    }

    private lazy var userProfileEditBtn = UIButton().then {
        $0.setImage(UIImage(named: "icProfileBtnMore"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.semanticContentAttribute = .forceRightToLeft
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        $0.contentVerticalAlignment = .center
        $0.press {
            let storyboard = UIStoryboard(name: "ShowMore", bundle: nil)
            let NicknameChangeVC = storyboard.instantiateViewController(identifier: "NicknameChangeVC") as! NicknameChangeVC
            self.navigationController?.pushViewController(NicknameChangeVC, animated: true)
        }
    }
    
    private lazy var userEmailLabel = UILabel()
    
    private lazy var showmoreTableView = UITableView().then {
        if #available(iOS 15.0, *) {
            // https://developer.apple.com/documentation/uikit/uitableview/3750914-sectionheadertoppadding?language=objc
            $0.sectionHeaderTopPadding = 1
        }
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
    }
    
    // MARK: Variables
    
    private let userId: Int = UserDefaults.standard.integer(forKey: "userID")
    private let sectionTitle = (["About Cherish", "개인정보처리방침", "서비스이용약관", "오픈소스라이센스", "1대1 문의하기"],
                                ["물주기 알림", "잠금 설정"],
                                ["로그아웃", "회원탈퇴"])
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        self.addNotificationObserver()
        self.showmoreTableView.register(ShowMoreCell.self, forCellReuseIdentifier: ShowMoreCell.className)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setUserInfo()
        self.setUserImage()
        self.showmoreTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
}

// MARK: Extension

extension ShowMoreVC {
    
    // MARK: Layout
    
    private func setLayout() {
        setViewTitle()
        setProfileArea()
        setTableViewLayout()
    }
    
    private func setViewTitle() {
        self.view.add(viewTitleLabel) {
            $0.snp.makeConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(13)
                $0.left.equalToSuperview().offset(23)
            }
        }
    }
    
    private func setProfileArea() {
        self.view.adds([userProfileImageView, userProfileEditBtn, userEmailLabel]) {
            $0[0].snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.viewTitleLabel.snp.bottom).offset(36)
                $0.width.height.equalTo(88.adjusted)
            }
            $0[0].makeRounded(cornerRadius: 88.adjusted/2)
            
            $0[1].snp.makeConstraints {
                $0.centerX.equalTo(self.userProfileImageView)
                $0.top.equalTo(self.userProfileImageView.snp.bottom).offset(11)
            }
            
            $0[2].snp.makeConstraints {
                $0.centerX.equalTo(self.userProfileImageView)
                $0.top.equalTo(self.userProfileEditBtn.snp.bottom).offset(3)
            }
        }
    }
    
    
    private func setTableViewLayout() {
        self.view.add(showmoreTableView) {
            $0.snp.makeConstraints {
                $0.top.equalTo(self.userEmailLabel.snp.bottom).offset(28)
                $0.left.right.equalToSuperview()
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
    }
    
    //MARK: - Private functions
    
    private func setUserInfo() {
        let myPageUserIdx = UserDefaults.standard.integer(forKey: "userID")
        MypageService.shared.inquireMypageView(idx: myPageUserIdx) { [self]
            (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let mypageData = data as? MypageData {
                    userProfileEditBtn.setButton(title: "\(mypageData.userNickname)", size: 18, weight: .bold)
                    UserDefaults.standard.set(mypageData.email, forKey: "userEmail")
                    UserDefaults.standard.set(mypageData.userNickname, forKey: "userNickname")
                }
            case .requestErr(let msg):
                print(msg)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func willEnterForeground() {
        showmoreTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    private func setUserImage() {
        if let image: UIImage
            = ImageFileManager.shared.getSavedImage(named: UserDefaults.standard.string(forKey: "uniqueImageName") ?? "") {
            userProfileImageView.image = image
        } else {
            userProfileImageView.image = UIImage(named: "userImg")
        }
    }
    
    private func logoutAlert() {
        self.makeAlertWithCancel(title: "로그아웃", message: "정말로 로그아웃 하시겠습니가?") { [weak self] _ in
            //로그아웃하기 위해 자동로그인을 위해 사용되었던
            //UserDefualts에 저장된 값들을 삭제해준다
            UserDefaults.standard.removeObject(forKey: "loginEmail")
            UserDefaults.standard.removeObject(forKey: "loginPw") // 로그인을 시키는게 아니라면 굳이 필요한가
            self?.fcmTokenDelete()
            
            // 자동로그인 해제시 루트 컨트롤러를 로그인으로 설정
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            guard let loginView = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
            guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
            let rootView = NavigationController(rootViewController: loginView)
            window.rootViewController = rootView
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
        }
    }
    
    private func withdrawalAlert() {
        self.makeAlertWithCancel(title: "정말 계정을 삭제하시겠어요?", message: "소중한 식물들이 모두 삭제되고 되돌릴 수 없어요.",
                                 okTitle: "네, 삭제할게요.", okStyle: .destructive, cancelTitle:  "계속 함께 할게요!") { _ in
            WithdrawalService.shared.withdrawalAccount(userId: UserDefaults.standard.integer(forKey: "userID")) { (networkResult) -> (Void) in
                switch networkResult {
                case .success(_):
                    //Delete Auto-Login Info of UserDefualts
                    UserDefaults.standard.removeObject(forKey: "loginEmail")
                    UserDefaults.standard.removeObject(forKey: "loginPw")
                    UserDefaults.standard.removeObject(forKey: "autoLogin")
                    
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    guard let loginView = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
                    let rootView = UINavigationController(rootViewController: loginView)
                    UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController = rootView
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
    }
    
    private func fcmTokenDelete() {
        // 서버에 업데이트된 fcmToken을 put
        FCMTokenDeleteService.shared.deleteFCMToken(userId: userId) {
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
    
    private func setAlarmSwitchStatus(_ toggle: UISwitch) {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                DispatchQueue.main.async {
                    toggle.isOn = false
                    print("notDetermined")
                }
            } else if settings.authorizationStatus == .denied {
                DispatchQueue.main.async {
                    toggle.isOn = false
                    print("denied")
                }
            } else if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    toggle.isOn = true
                    print("authorized")
                }
            }
        })
    }
    
    private func setPWSwitchStatus(_ toggle: UISwitch) {
        if let _ = UserDefaults.standard.value(forKey: "AppLockPW") {
            toggle.isOn = true
        } else {
            toggle.isOn = false
        }
    }
}

// MARK: Protocols

extension ShowMoreVC: UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sectionTitle.0.count
        case 1:
            return sectionTitle.1.count
        case 2:
            return sectionTitle.2.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowMoreCell.className, for: indexPath) as? ShowMoreCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            cell.section = .btn
            cell.setData(sectionTitle.0[indexPath.row])
        case 1:
            switch indexPath.row {
            case 0:
                setAlarmSwitchStatus(cell.toggleSwitch)
            case 1:
                setPWSwitchStatus(cell.toggleSwitch)
            default:
                break
            }
            cell.section = .toggle
            cell.showMoreDelegate = self
            cell.setData(sectionTitle.1[indexPath.row])
        case 2:
            cell.section = .none
            cell.setData(sectionTitle.2[indexPath.row])
        default:
            break
        }
        cell.awakeFromNib()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView().then {
            $0.backgroundColor = .inputGrey
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 1.0
        default:
            return 6.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let storyboard = UIStoryboard(name: "ShowMore", bundle: nil)
                guard let vc = storyboard.instantiateViewController(withIdentifier: "AboutCherishVC") as? AboutCherishVC else { break }
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 1:
                let url = NSURL(string: "https://www.notion.so/Cherish-2d35c1bffa2f4d49943db302d76e3cac")
                guard let newURL = url as URL? else { break }
                let safari: SFSafariViewController = SFSafariViewController(url: newURL)
                self.present(safari, animated: true, completion: nil)
                
            case 2:
                let url = NSURL(string: "https://www.notion.so/Cherish-d96f88172ffa4d80b257665849bddc65")
                guard let newURL = url as URL? else { break }
                let safari: SFSafariViewController = SFSafariViewController(url: newURL)
                self.present(safari, animated: true, completion: nil)
                
            case 3:
                let storyboard = UIStoryboard(name: "ShowMore", bundle: nil)
                guard let vc = storyboard.instantiateViewController(withIdentifier: "OpenSourcesVC") as? OpenSourcesVC else { break }
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 4:
                if MFMailComposeViewController.canSendMail() {
                    let compseVC = MFMailComposeViewController().then {
                        $0.mailComposeDelegate = self
                        $0.setToRecipients(["Co.Cherishteam@gmail.com"])
                        $0.setSubject("체리쉬 문의")
                        $0.setMessageBody("1. 문의 유형(문의, 버그 제보, 기타) : \n 2. 회원 닉네임(필요시 기입) : \n 3. 문의 내용 : \n \n \n 문의하신 사항은 체리쉬팀이 신속하게 처리하겠습니다. 감사합니다 :)", isHTML: false)
                    }
                    self.present(compseVC, animated: true, completion: nil)
                }
                else {
                    self.makeAlert(title: "메일 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.")
                }
            default:
                break
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                logoutAlert()
            case 1:
                withdrawalAlert()
            default:
                break
            }
            
        default:
            break
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ShowMoreVC: ShowMoreSwitchDelegate {
    func switchAction(sender: UISwitch, idx: Int) {
        switch idx {
        case 0:
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings { permission in
                switch permission.authorizationStatus {
                case .denied:
                    DispatchQueue.main.async {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                case .authorized:
                    DispatchQueue.main.async {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                default:
                    break
                }
            }
        case 1:
            // OFF -> ON
            if sender.isOn {
                let lock = SetLockVC()
                lock.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(lock, animated: true)
            // ON -> OFF
            } else {
                UserDefaults.standard.removeObject(forKey: "AppLockPW")
            }
        default:
            break
        }
    }
}
