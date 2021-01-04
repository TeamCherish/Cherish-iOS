//
//  SelectFriendVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/03.
//

import UIKit

class SelectFriendVC: UIViewController {

    @IBOutlet weak var searchFriendTextField: UITextField!
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var nextLabel: UILabel!
    
    var friendList: [Friend] = []
    var name = [String]()
    var phoneNumber = [String]()
    
    var filteredNameData = [String]()
    var filteredPhoneNumberData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetSelectFriendVC()
        setSearchFriendTextField()
        enableNextBtn()
        setFriendData()
        setNameData()
        setPhoneNumberData()
        friendTableView.separatorStyle = .none
        friendTableView.dataSource = self
        friendTableView.delegate = self
        searchFriendTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func resetSelectFriendVC() {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func touchUpClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func touchUpNext(_ sender: Any) {
        if nextBtn.isEnabled == true {
            guard let dvc = self.storyboard?.instantiateViewController(identifier: "InputDetailVC") else {
                return
            }
            self.present(dvc, animated: true, completion: nil)
        }
    }
    
    //MARK: - 텍스트필드 값 지정 함수
    func setSearchFriendTextField() {
        searchFriendTextField.addSelectRightPadding()
        searchFriendTextField.background = UIImage(named: "search_box")
        searchFriendTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
        searchFriendTextField.layer.borderWidth = 0
    }
    
    func enableNextBtn() {
        nextBtn.isEnabled = false
        
    }
    
    func setFriendData() {
        friendList.append(contentsOf: [
            Friend(name: "김웅앵", phoneNumber: "010-0000-0000"),
            Friend(name: "박웅앵", phoneNumber: "010-0000-0001"),
            Friend(name: "이웅앵", phoneNumber: "010-0000-0002"),
            Friend(name: "황웅앵", phoneNumber: "010-0000-0003"),
            Friend(name: "장웅앵", phoneNumber: "010-0000-0004"),
            Friend(name: "최웅앵", phoneNumber: "010-0000-0005"),
            Friend(name: "한웅앵", phoneNumber: "010-0000-0006"),
            Friend(name: "고웅앵", phoneNumber: "010-0000-0007")
        ])
    }
    
    func setNameData() {
        name.append("김웅앵")
        name.append("박웅앵")
        name.append("이웅앵")
        name.append("황웅앵")
        name.append("장웅앵")
        name.append("최웅앵")
        name.append("한웅앵")
        name.append("고웅앵")
    }
    
    func setPhoneNumberData() {
        phoneNumber.append("010-0000-0000")
        phoneNumber.append("010-0000-0001")
        phoneNumber.append("010-0000-0002")
        phoneNumber.append("010-0000-0003")
        phoneNumber.append("010-0000-0004")
        phoneNumber.append("010-0000-0005")
        phoneNumber.append("010-0000-0006")
        phoneNumber.append("010-0000-0007")
    }
}

extension SelectFriendVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredNameData.isEmpty {
            return filteredNameData.count
        }
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier) as? FriendCell else {
            return UITableViewCell()
        }
        if !filteredNameData.isEmpty {
            cell.setName(name: filteredNameData[indexPath.row])
//            cell.setPhoneNumber(phoneNumber: filteredPhoneNumberData[indexPath.row])
        }
        cell.setCell(friend: friendList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.isEmpty == false {
            self.nextBtn.isEnabled = true
            self.nextBtn.setImage(UIImage(named: "btn_next_selected"), for: .normal)
            self.nextLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        }
    }
}

extension SelectFriendVC: UITextFieldDelegate {
    func filterText(_ query: String?) {
        guard let query = query else {
            return
        }
        print("\(query)")
        filteredNameData.removeAll()
        filteredPhoneNumberData.removeAll()
        
        for string in name {
            if string.lowercased().starts(with: query.lowercased()) {
                filteredNameData.append(string)
            }
        }
//        friendTableView.reloadData
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = searchFriendTextField.text {
            filterText(text + string)
        }
        return true
    }
}
