//
//  ShowMoreVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit

class ShowMoreVC: UIViewController {
    let settingName = ["공지사항","문의하기","알림설정"]
    let lockName = ["Face ID 사용", "비밀번호 변경"]
    let imageIcon = ["settingIcNotice","settingIcMessage","settingIcAlarm"]
    @IBOutlet weak var topNaviBar: UIView!{
        didSet{
            topNaviBar.dropShadow(color: .showmoreShadow, offSet: CGSize(width: 0, height: 1), opacity: 0.7, radius: 0)
        }
    }
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var showMoreTableView: UITableView!{
        didSet{
            showMoreTableView.delegate = self
            showMoreTableView.dataSource = self
            showMoreTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude) // 테이블 뷰 경계션 없애기
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showMoreTableView.tableHeaderView = HeaderView
        showMoreTableView.register(ShowMoreTVC.nib(), forCellReuseIdentifier: ShowMoreTVC.identifier)
        // Do any additional setup after loading the view.
    }
}

extension ShowMoreVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 3
        }else if section == 2 {
            return 2
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 50
        }else if indexPath.section == 2 {
            return 50
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 1){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowMoreTVC.identifier) as? ShowMoreTVC else{
                return UITableViewCell()}
            cell.setImageCell(imageName: imageIcon[indexPath.row], labelName: settingName[indexPath.row])
            
            return cell
            
        }else if (indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowMoreNotImageTVC", for: indexPath) as! ShowMoreNotImageTVC
            cell.showmoreNotImageLabel.text = lockName[indexPath.row]
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else if section == 1{
            return 8
        }else if section == 2{
            return 42
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else if section == 1{
            return 8
        }else if section == 2{
            return 8
        }else{
            return 0
        }
    }
}
