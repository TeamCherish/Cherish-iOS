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
    
    //MARK: -@IBOutlet
    @IBOutlet weak var topNaviBar: UIView!{
        didSet{
            topNaviBar.dropShadow(color: .showmoreShadow, offSet: CGSize(width: 0, height: 1), opacity: 0.1, radius: 0)
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
    @IBOutlet weak var userNameLabel: CustomLabel!
    @IBOutlet weak var userSubInfoLabel: CustomLabel!{
        didSet{
            userSubInfoLabel.textColor = .showmoreGrey
        }
    }
    @IBOutlet weak var synchronizationLabel: CustomLabel!{
        didSet{
            synchronizationLabel.textColor = .showmoreGrey
        }
    }
    @IBOutlet var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMoreTableView.tableHeaderView = HeaderView
        showMoreTableView.register(ShowMoreTVC.nib(), forCellReuseIdentifier: ShowMoreTVC.identifier)
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        // Do any additional setup after loading the view.
    }
    @IBAction func doSynchronization(_ sender: Any) {
        alertForm(title: "Cherish", message: "동기화가 완료 되었습니다!")
    }
    
    func alertForm(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Alert의 '확인'을 누르면 dismiss
        let okAction = UIAlertAction(title: "확인",style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

//MARK: -Delegate & DataSource
extension ShowMoreVC: UITableViewDelegate, UITableViewDataSource{
    /// 셀 선택 시 수행할 작업
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        /// 회색으로 선택을 표시해주고 사라지도록
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    /// 섹션 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /// 섹션 별 셀 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 3
        }else if section == 2 {
            return 2
        }else{
            return 0
        }
    }
    
    /// 섹션 별 셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 50
        }else if indexPath.section == 2 {
            return 50
        }else{
            return 0
        }
    }
    
    /// 섹션 별 셀 지정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 1){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowMoreTVC.identifier) as? ShowMoreTVC else{
                return UITableViewCell()}
            //            cell.selectionStyle = .none
            cell.setImageCell(imageName: imageIcon[indexPath.row], labelName: settingName[indexPath.row])
            
            return cell
            
        }else if (indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowMoreNotImageTVC", for: indexPath) as! ShowMoreNotImageTVC
            //            cell.selectionStyle = .none
            cell.showmoreNotImageLabel.text = lockName[indexPath.row]
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    /// 섹션 헤더 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else if section == 1{
            return 8
        }else if section == 2{
            return 40
        }else{
            return 0
        }
    }
    
    /// 섹션 푸터 높이
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
    
    /// 섹션 헤더 뷰 구성
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if section == 1{
            let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 8)) //set these values as necessary
            returnedView.backgroundColor = .inputGrey
            
            return returnedView
        }else if section == 2{
            let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)) //set these values as necessary
            returnedView.backgroundColor = .white
            
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width, height: 40))
            label.font = UIFont(name: "NotoSansCJKKR-Medium", size: 14)
            label.textColor = .showmoreGrey
            label.text = "잠금 설정"
            returnedView.addSubview(label)
            
            return returnedView
        }
        return nil
    }
    
    /// 섹션 푸터 뷰 구성
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 || section == 2{
            let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 8)) //set these values as necessary
            returnedView.backgroundColor = .inputGrey
            
            return returnedView
        }else{
            return nil
        }
    }
}
