//
//  SelectFriendSearchBar.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/08.
//

import UIKit

class SelectFriendSearchBar: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    struct Friend {
        var name: String
        var phoneNumber: String
        var selected: Bool
    }
    
    var friendList: [Friend] = [
        Friend(name: "김웅앵", phoneNumber: "010.1111.1111", selected: false),
        Friend(name: "박웅앵", phoneNumber: "010.2222.1111", selected: false),
        Friend(name: "이웅앵", phoneNumber: "010.3333.1111", selected: false),
        Friend(name: "한웅앵", phoneNumber: "010.4444.1111", selected: false),
        Friend(name: "장웅앵", phoneNumber: "010.5555.1111", selected: false),
        Friend(name: "황웅앵", phoneNumber: "010.6666.1111", selected: false),
        Friend(name: "황웅앵", phoneNumber: "010.7777.1111", selected: false),
        Friend(name: "안웅앵", phoneNumber: "010.8888.1111", selected: false),
        Friend(name: "권웅앵", phoneNumber: "010.9999.1111", selected: false)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: radioButton, bundle: nil), forCellReuseIdentifier: radioButton)
        resetSelectFriendVC()
        setSearchBar()
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
    }
    
    func resetSelectFriendVC() {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func updateSelectedIndex(_ index: Int) {
        selectedFriend = index
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 1
        guard let cell = tableView.dequeueReusableCell(withIdentifier: radioButton, for: indexPath) as? SelectFriendCell else { fatalError("Cell Not Found") }
        
        // 2
        cell.selectionStyle = .none
        
        // 3
        let friend = friendList[indexPath.row]
        
        // 4
        let currentIndex = indexPath.row
        
        // 5
        let selected = currentIndex == selectedFriend
        
        // 6
        cell.configureName(friend.name)
        cell.configurePhone(friend.phoneNumber)

        // 7
        cell.isselected(selected)
        
        // 8
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateSelectedIndex(indexPath.row)
    }
}
