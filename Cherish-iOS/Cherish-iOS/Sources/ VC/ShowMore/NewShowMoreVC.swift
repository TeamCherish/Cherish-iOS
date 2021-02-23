//
//  NewShowMoreVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/02/23.
//

import UIKit

class NewShowMoreVC: UIViewController {
    
    @IBOutlet var showMoreTV: UITableView!
    var infoTitleArray:[String] = ["About Cherish", "개인정보처리방침", "서비스이용약관", "1대1 문의하기"]
    var logInfoTitleArray:[String] = ["로그아웃", "회원탈퇴"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        // Do any additional setup after loading the view.
    }
    
    func setDelegates() {
        showMoreTV.delegate = self
        showMoreTV.dataSource = self
        showMoreTV.separatorStyle = .none
    }
    
    @IBAction func touchUpToChangeNickname(_ sender: UIButton) {
        print("닉네임 바꾼닷")
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
            if indexPath.row == 0 {
                print("section 0, row 0")
            }
            else if indexPath.row == 1 {
                print("section 0, row 1")
            }
            else if indexPath.row == 2 {
                print("section 0, row 2")
            }
            else {
                print("section 0, row 3")
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                print("section 2, row 0")
            }
            else {
                print("section 2, row 1")
            }
        }
    }
}
