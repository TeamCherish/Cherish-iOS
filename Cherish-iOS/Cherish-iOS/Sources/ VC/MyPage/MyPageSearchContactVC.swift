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
    @IBOutlet weak var moveToAddLabel: CustomLabel!
    
    var friendList: [Friend] = []
    
    var index: Int = 0
    
    private var selectedFriend: Int? {
        didSet {
            contactTV.reloadData()
            self.moveToAddBtn.isEnabled = true
            self.moveToAddBtn.setImage(UIImage(named: "btn_next_selected"), for: .normal)
            self.moveToAddLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
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
        contactTV.tableFooterView = UIView()
        contactTV.register(UINib(nibName: radioButton, bundle: nil), forCellReuseIdentifier: radioButton)
        resetSelectFriendVC()
        filteredData = friendList
        setSearchBar()
        getContacts()
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
//        if section == 0 {
//            return 1
//        }
        if filteredData == nil {
            return friendList.count
        }
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

        if moveToAddBtn.isEnabled == true {
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddUser", bundle: nil)
            if let vc = storyboard?.instantiateViewController(identifier: "InputDetailVC") as? InputDetailVC {
                // 이름, 전화번호 텍필로 넘겨주기
                if checkSearch == 0 {
                    // 검색창 사용 X
                    vc.givenName = friendList[index].name
                    vc.givenPhoneNumber = friendList[index].phoneNumber
                }
                else if checkSearch == 1 {
                    // 검색창 사용 O
                    vc.givenName = filteredData[index].name
                    vc.givenPhoneNumber = filteredData[index].name
                }
                
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
