//
//  SelectFriendVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/03.
//

import UIKit

class SelectFriendVC: UIViewController {

    //MARK: - IBOutlet
//
//    @IBOutlet weak var searchFriendTextField: UITextField!
//    @IBOutlet weak var friendTableView: UITableView!
//    @IBOutlet weak var nextBtn: UIButton!
//    @IBOutlet weak var nextLabel: UILabel!
    
//MARK: - 변수 선언
//    var friendList: [Friend] = []
//    var name = [String]()
//    var phoneNumber = [String]()
//    var filteredNameData = [String]()
//    var filteredPhoneNumberData = [String]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(activeNextBtn(_:)), name: .radioBtnClicked, object: nil)
//
//        resetSelectFriendVC()
//        setSearchFriendTextField()
//        enableNextBtn()
//        setFriendData()
//        setNameData()
//        setPhoneNumberData()
//        friendTableView.separatorStyle = .none
//        friendTableView.dataSource = self
//        friendTableView.delegate = self
//        friendTableView.register(UINib(nibName: radioButton, bundle: nil), forCellReuseIdentifier: radioButton)
//        searchFriendTextField.delegate = self
        // Do any additional setup after loading the view.
//    }
//    private let radioButton = "FriendCell"
//
//    @objc func activeNextBtn(_ notification: Notification) {
//        self.nextBtn.isEnabled = true
//        self.nextBtn.setImage(UIImage(named: "btn_next_selected"), for: .normal)
//        self.nextLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
//    }
//
//    //MARK: - VC navigation bar, tab bar 삭제
//    func resetSelectFriendVC() {
//        self.navigationController?.navigationBar.isHidden = true
//        self.tabBarController?.tabBar.isHidden = true
//    }
//
//
//    //MARK: - IBAction
//
//    @IBAction func touchUpClose(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    @IBAction func touchUpNext(_ sender: Any) {
//        if nextBtn.isEnabled == true {
//            guard let dvc = self.storyboard?.instantiateViewController(identifier: "InputDetailVC") else {
//                return
//            }
//            self.present(dvc, animated: true, completion: nil)
//        }
//    }
//
//
//    //MARK: - 텍스트필드 값 지정 함수
//    func setSearchFriendTextField() {
//        searchFriendTextField.addSelectRightPadding()
//        searchFriendTextField.background = UIImage(named: "search_box")
//        searchFriendTextField.layer.borderColor = CGColor(gray: 0, alpha: 0)
//        searchFriendTextField.layer.borderWidth = 0
//    }
//
//    //MARK: - radioBtn 선택되면 다음 버튼 활성화
//    func enableNextBtn() {
//        nextBtn.isEnabled = false
//
//    }
//
//    //MARK: - TableView Cell에 데이터 뿌리기
//    func setFriendData() {
//        friendList.append(contentsOf: [
//            Friend(name: "김웅앵", phoneNumber: "010-0000-0000"),
//            Friend(name: "박웅앵", phoneNumber: "010-0000-0001"),
//            Friend(name: "이웅앵", phoneNumber: "010-0000-0002"),
//            Friend(name: "황웅앵", phoneNumber: "010-0000-0003"),
//            Friend(name: "장웅앵", phoneNumber: "010-0000-0004"),
//            Friend(name: "최웅앵", phoneNumber: "010-0000-0005"),
//            Friend(name: "한웅앵", phoneNumber: "010-0000-0006"),
//            Friend(name: "고웅앵", phoneNumber: "010-0000-0007")
//        ])
//    }
//
//    private func updateSelectedIndex(_ index: Int) {
//        selectedCell = index
//    }
//
//    private var selectedCell: Int? {
//        didSet {
//            friendTableView.reloadData()
//        }
//    }
    
//    func setNameData() {
//        name.append("김웅앵")
//        name.append("박웅앵")
//        name.append("이웅앵")
//        name.append("황웅앵")
//        name.append("장웅앵")
//        name.append("최웅앵")
//        name.append("한웅앵")
//        name.append("고웅앵")
//    }
//
//    func setPhoneNumberData() {
//        phoneNumber.append("010.0000.0000")
//        phoneNumber.append("010.1000.0001")
//        phoneNumber.append("010.2000.0002")
//        phoneNumber.append("010.3000.0003")
//        phoneNumber.append("010.4000.0004")
//        phoneNumber.append("010.5000.0005")
//        phoneNumber.append("010.6000.0006")
//        phoneNumber.append("010.7000.0007")
//    }
}


//MARK: - tableview dataSource, delegate
//extension SelectFriendVC: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return friendList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier) as? FriendCell else {
//            return UITableViewCell()
//        }
//        cell.selectionStyle = .none
//        let friendRadio = friendList[indexPath.row]
//        let currentIndex = indexPath.row
//        let selected = currentIndex == selectedCell
//        cell.isSelected(selected)
//        cell.setName(name: name[indexPath.row])
//        cell.setPhoneNumber(phoneNumber: phoneNumber[indexPath.row])
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        updateSelectedIndex(indexPath.row)
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier) as? FriendCell else {return}
//
//        if cell.activeBtn == true {
//            self.nextBtn.isEnabled = true
//            self.nextBtn.setImage(UIImage(named: "btn_next_selected"), for: .normal)
//            self.nextLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
//        }
        
//        if indexPath.isEmpty == false {
//            cell.radioBtn.setImage(UIImage(named: "btn_checkbox_selected"), for: .normal)
//            tableView.reloadData()
//            self.nextBtn.isEnabled = true
//            self.nextBtn.setImage(UIImage(named: "btn_next_selected"), for: .normal)
//        }
//    }
//}

