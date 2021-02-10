//
//  SelectFriendSearchBar.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/08.
//

import UIKit

class SelectFriendSearchBar: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var friendList: [Friend] = []
    
    var index: Int = 0
    
    private var selectedFriend: Int? {
        didSet {
            tableView.reloadData()
            self.nextBtn.isEnabled = true
            self.nextBtn.setImage(UIImage(named: "btn_next_selected"), for: .normal)
            self.nextLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
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
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: radioButton, bundle: nil), forCellReuseIdentifier: radioButton)
        resetSelectFriendVC()
        setSearchBar()
        getContacts()
        filteredData = friendList
        //Array
        //        NotificationCenter.default.addObserver(self, selector: #selector(activeNextBtn(_:)), name: .radioBtnClicked, object: nil)
    }
    //    @objc func activeNextBtn(_ notification: Notification) {
    //        self.nextBtn.isEnabled = true
    //        self.nextBtn.setImage(UIImage(named: "btn_next_selected"), for: .normal)
    //        self.nextLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    //    }
    @IBAction func closeToMain(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func touchUpNextBtn(_ sender: Any) {
        if nextBtn.isEnabled == true {
            
            // 중복 검사 여기서!
            // 다음 버튼 눌렀을 때 -> 어떤 cell이 선택된건지 정보 받아와서 그거 폰 번호로 중복 검사 하면 될듯

            guard let dvc = self.storyboard?.instantiateViewController(identifier: "InputDetailVC") as? InputDetailVC else {return}
            
            
            // 만약 검색창이 사용되지 않았으면 -> friendList에서
            // 검색창이 사용됐으면 -> filteredData 에서
            
            if checkSearch == 0 {
                dvc.givenName = friendList[index].name
                dvc.givenPhoneNumber = friendList[index].phoneNumber
            }
            
            else if checkSearch == 1 {
                dvc.givenName = filteredData[index].name
                dvc.givenPhoneNumber = filteredData[index].phoneNumber
            }
            
            
            dvc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(dvc, animated: true)
        }
    }
        
    func getContacts() {
        if let data = UserDefaults.standard.value(forKey: "userContacts") as? Data {
            let contacts = try? PropertyListDecoder().decode([Friend].self, from: data)

            friendList = contacts!
//            print(friendList)
            
        }
    }
    
    
    func setSearchBar() {
        searchBar.placeholder = "친구 검색"
        searchBar.setImage(UIImage(named: "icn_search_box"), for: UISearchBar.Icon.search, state: .normal)
        searchBar.layer.borderWidth = 0
        searchBar.searchBarStyle = .minimal
        searchBar.setSearchFieldBackgroundImage(UIImage(named: "search_box"), for: .normal)
        searchBar.sizeToFit()
        searchBar.searchTextField.sizeToFit()
        searchBar.searchTextField.textColor = UIColor.black
        searchBar.searchTextField.font = UIFont.init(name: "NotoSansCJKKR-Regular", size: 14)
    }
    
    func resetSelectFriendVC() {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func updateSelectedIndex(_ index: Int) {
        selectedFriend = index
    }
    
    
    //MARK: - tableView delegate, datasource
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: radioButton, for: indexPath) as? SelectFriendCell else { fatalError("Cell Not Found") }
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
    
    //MARK: - searchBar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == "" {
            filteredData = friendList
        }
        else {
            checkSearch = 1
            
            for friend in friendList {
                if friend.name.contains(searchText) {
                    filteredData.append(contentsOf: [
                                            Friend(name: friend.name, phoneNumber: friend.phoneNumber, selected: friend.selected)])
                }
                else if friend.phoneNumber.contains(searchText) {
                    filteredData.append(contentsOf: [Friend(name: friend.name, phoneNumber: friend.phoneNumber, selected: friend.selected)])
                }
                
            }
            
        }
        self.tableView.reloadData()
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
}

