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
    
    struct Friend {
        var name: String
        var phoneNumber: String
        var selected: Bool
    }
    
    let topInset: CGFloat = 36.0
    
    var friendList: [Friend] = [
        Friend(name: "김웅앵", phoneNumber: "01011111111", selected: false),
        Friend(name: "박웅앵", phoneNumber: "01022221111", selected: false),
        Friend(name: "이웅앵", phoneNumber: "01033331111", selected: false),
        Friend(name: "한웅앵", phoneNumber: "01044441111", selected: false),
        Friend(name: "장웅앵", phoneNumber: "01055551111", selected: false),
        Friend(name: "황웅앵", phoneNumber: "01066661111", selected: false),
        Friend(name: "황웅앵", phoneNumber: "01077771111", selected: false),
        Friend(name: "안웅앵", phoneNumber: "01088881111", selected: false),
        Friend(name: "권웅앵", phoneNumber: "01099991111", selected: false)
    ]
    
    
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
        filteredData = friendList
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
            guard let dvc = self.storyboard?.instantiateViewController(identifier: "InputDetailVC") else {
                return
            }
            self.present(dvc, animated: true, completion: nil)
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
    }
    
    
    
    
    //MARK: - searchBar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == "" {
            filteredData = friendList
        }
        else {
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
}

