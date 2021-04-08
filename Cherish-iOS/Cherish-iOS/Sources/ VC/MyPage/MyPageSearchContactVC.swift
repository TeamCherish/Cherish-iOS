//
//  MyPageSearchContactVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/02/22.
//

import UIKit

class MyPageSearchContactVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var contactTV: UITableView!
    @IBOutlet weak var contactSearchBar: UISearchBar!
    @IBOutlet weak var moveToAddBtn: UIButton!
    
    var friendList: [Friend] = []
    
    var index: Int = 0
    
    private var selectedFriend: Int? {
        didSet {
            contactTV.reloadData()
            self.moveToAddBtn.isEnabled = true
            self.moveToAddBtn.setBackgroundImage(UIImage(named: "btn_next_selected"), for: .normal)
        }
    }
    
    private let radioButton = "SelectFriendCell"
    
    //MARK: - searchBar 관련
    var filteredData: [Friend]!
    
    var nameTextFrom: String = ""
    var phoneNumFrom: String = ""
    
    
    var fetchedName: [String] = []
    var fetchedPhoneNumber: [String] = []
    
    var checkSearch: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTV.separatorStyle = .none
        contactTV.delegate = self
        contactTV.dataSource = self
        contactSearchBar.delegate = self
        setSearchBar()
        getContacts()
        contactTV.reloadData()
        contactTV.tableFooterView = UIView()
        contactTV.register(UINib(nibName: radioButton, bundle: nil), forCellReuseIdentifier: radioButton)
        resetSelectFriendVC()
        filteredData = friendList
//        moveToAddBtn.isEnabled = false
        self.moveToAddBtn.setBackgroundImage(UIImage(named: "btnNextUnselected"), for: .normal)
        moveToAddBtn.layer.zPosition = 1
        self.view.bringSubviewToFront(moveToAddBtn)
    }
    
    func setSearchBar() {
        contactSearchBar.placeholder = "연락처 검색"
        contactSearchBar.setImage(UIImage(named: "icn_search_box"), for: UISearchBar.Icon.search, state: .normal)
        contactSearchBar.layer.borderWidth = 0
        contactSearchBar.searchBarStyle = .minimal
        contactSearchBar.setSearchFieldBackgroundImage(UIImage(named: "search_box"), for: .normal)
        contactSearchBar.sizeToFit()
        contactSearchBar.searchTextField.sizeToFit()
        contactSearchBar.searchTextField.textColor = UIColor.black
        contactSearchBar.searchTextField.font = UIFont.init(name: "NotoSansCJKKR-Regular", size: 14)
    }
    
    func getContacts() {
        if let data = UserDefaults.standard.value(forKey: "userContacts") as? Data {
            let contacts = try? PropertyListDecoder().decode([Friend].self, from: data)
            
            friendList = contacts!
            
            // 숫자 -> 한글 가나다순 -> 영어순으로 정렬
            friendList = friendList.sorted(by: {$0.name.localizedStandardCompare($1.name) == .orderedAscending })
            // 숫자로 시작하는 문자열 추출 후 저장
            let startNumberArray = friendList.filter{$0.name.first?.isNumber == true}
            // 문자로 시작하는 문자열만 추출해서 저장
            friendList = friendList.filter{$0.name.first?.isNumber == false}
            // 문자로 시작하는 문자열 뒤에 숫자로 시작하는 문자열 병합
            friendList.append(contentsOf: startNumberArray)
        }
    }
    
    func resetSelectFriendVC() {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func updateSelectedIndex(_ index: Int) {
        selectedFriend = index
    }
    

    // MARK: - 테이블뷰 delegate, datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if filteredData == nil {
            return friendList.count
        }
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = contactTV.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        guard let cell = contactTV.dequeueReusableCell(withIdentifier: radioButton, for: indexPath) as? SelectFriendCell else { fatalError("Cell Not Found")}
        cell.selectionStyle = .none
        let friend = filteredData[indexPath.row]
        let currentIndex = indexPath.row
        let selected = currentIndex == selectedFriend
        cell.configureName(friend.name)
        cell.configurePhone(friend.phoneNumber)
        cell.isselected(selected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateSelectedIndex(indexPath.row)
        index = indexPath.row
        print(index)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 28
        }
        return 83
    }
    
    // MARK: - searchBar delegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == "" {
            filteredData = friendList
        }
        else {
            checkSearch = 1
            
            for friend in friendList {
                if friend.name.contains(searchText) {
                    filteredData.append(contentsOf: [Friend(name: friend.name, phoneNumber: friend.phoneNumber, selected: friend.selected)])
                    print("하이하이하이")
                }
                else if friend.phoneNumber.contains(searchText) {
                    filteredData.append(contentsOf: [Friend(name: friend.name, phoneNumber: friend.phoneNumber, selected: friend.selected)])
                }
            }
        }
        self.contactTV.reloadData()
    }
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        contactSearchBar.searchTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contactSearchBar.endEditing(true)
    }
    
    @IBAction func moveToAddUser(_ sender: Any) {
        
        print("안녕")

        if moveToAddBtn.isEnabled == true {
            print("뇽안")
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddUser", bundle: nil)
            guard let dvc = storyBoard.instantiateViewController(identifier: "InputDetailVC") as? InputDetailVC else {return}
            if checkSearch == 0 {
                dvc.givenName = friendList[index].name
                dvc.givenPhoneNumber = friendList[index].phoneNumber
            }
            else if checkSearch == 1 {
                dvc.givenName = filteredData[index].name
                dvc.givenPhoneNumber  = filteredData[index].phoneNumber
            }
            
            // 중복된 연락처라고 알려줄 팝업
            let alert = UIAlertController.init(title: "이미 등록된 연락처입니다", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            
            // 연락처 중복 검사
            CheckPhoneService.shared.checkPhone(phone: dvc.givenPhoneNumber!, UserId: UserDefaults.standard.integer(forKey: "userID")) { [self](networkResult) -> (Void) in
                switch networkResult {
                case .success(_):
                    print("통신성공")
                    dvc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(dvc, animated: true)
                case .requestErr(_):
                    print("requestErr")
                    present(alert, animated: true, completion: nil)
//                    moveToAddBtn.isEnabled = false
                    self.moveToAddBtn.setBackgroundImage(UIImage(named: "btnNextUnselected"), for: .normal)
                case .pathErr:
                    print("pathErr")
                    present(alert, animated: true, completion: nil)
//                    moveToAddBtn.isEnabled = false
                    self.moveToAddBtn.setBackgroundImage(UIImage(named: "btnNextUnselected"), for: .normal)
                case .serverErr:
                    print("serverErr")
                    present(alert, animated: true, completion: nil)
//                    moveToAddBtn.isEnabled = false
                    self.moveToAddBtn.setBackgroundImage(UIImage(named: "btnNextUnselected"), for: .normal)
                case .networkFail:
                    print("networkFail")
                    present(alert, animated: true, completion: nil)
//                    moveToAddBtn.isEnabled = false
                    self.moveToAddBtn.setBackgroundImage(UIImage(named: "btnNextUnselected"), for: .normal)
                }
            }
        }
    }
    
}
