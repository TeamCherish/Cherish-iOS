//
//  SelectFriendSearchBar.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/08.
//

import UIKit
import Contacts

class SelectFriendSearchBar: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var friendList: [Friend] = []
    
    var index: Int = 0
    
    var checkSelected: Bool = false
    
    private var selectedFriend: Int? {
        didSet {
            tableView.reloadData()
            print("골랐니?")
            checkSelected = true
            print(checkSelected)
            self.nextBtn.isEnabled = true
            self.nextBtn.setBackgroundImage(UIImage(named: "btn_next_selected"), for: .normal)
//            self.nextBtn.backgroundColor = .seaweed /// 이거 안됨
//            self.nextBtn.makeRounded(cornerRadius: 25)
            self.nextBtn.setTitleColor(UIColor(red: 255, green: 255, blue: 255, alpha: 1.0), for: .normal)
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
        /// 이렇게 하면 버튼 타이틀이 가운데로 안온다
//        nextBtn.isEnabled = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: radioButton, bundle: nil), forCellReuseIdentifier: radioButton)
        resetSelectFriendVC()
        setSearchBar()
        getContacts()
        requestAccess(completionHandler: {_ in })
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
        if checkSelected == true {

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
            
            // 중복된 연락처라고 알려줄 팝업
            let alert = UIAlertController.init(title: "이미 등록된 연락처입니다", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            
            var phoneNumber: String = dvc.givenPhoneNumber!
            var userId = UserDefaults.standard.integer(forKey: "userID")
            
            print("유저아이디~")
            print(userId)
            
            CheckPhoneService.shared.checkPhone(phone: phoneNumber , UserId: userId) { [self](networkResult) -> (Void) in
                switch networkResult {
                case .success(_):
                    print("통신성공")
                    dvc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(dvc, animated: true)
                case .requestErr(_):
                    print("requestErr")
                    present(alert, animated: true, completion: nil)
                    self.nextBtn.setBackgroundImage(UIImage(named: "btn_next_unselected"), for: .normal)
                    self.nextBtn.setTitleColor(.textGrey, for: .normal)
                    checkSelected = false
                case .pathErr:
                    print("pathErr")
                    present(alert, animated: true, completion: nil)
                    nextBtn.isEnabled = false
                case .serverErr:
                    print("serverErr")
                    present(alert, animated: true, completion: nil)
                    nextBtn.isEnabled = false
                case .networkFail:
                    print("networkFail")
                    present(alert, animated: true, completion: nil)
                    nextBtn.isEnabled = false
                }
            }
        }
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
    
    
    func setSearchBar() {
//        var imageView = UIImageView
        let frame = CGRect(x: 0, y: 0, width: 343, height: 44)
        searchBar.frame = frame
        searchBar.placeholder = "친구 검색"
        searchBar.setImage(UIImage(named: "icn_search_box"), for: UISearchBar.Icon.search, state: .normal)
//        searchBar.setImage(imageView, for: UISearchBar.Icon.search, state: .normal)
        searchBar.searchBarStyle = .minimal
        searchBar.setSearchFieldBackgroundImage(UIImage(named: "search_box"), for: .normal)
        searchBar.sizeToFit()
        searchBar.searchTextField.sizeToFit()
        searchBar.layer.borderWidth = 0
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 8.0, vertical: 0.0)
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
    
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let store = CNContactStore()
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        @unknown default:
            fatalError()
        }
    }

    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: "다음 작업을 위해 Cherish가 사용자의 연락처에 접근하는 것을 허용합니다.", message: "*Cherish에 휴대폰의 연락처를 동기화", preferredStyle: .alert)
        if
            let settings = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settings) {
                alert.addAction(UIAlertAction(title: "설정 열기", style: .default) { action in
                    completionHandler(false)
                    UIApplication.shared.open(settings)
                })
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { action in
            completionHandler(false)
        })
        present(alert, animated: true)
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

