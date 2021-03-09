//
//  MyPageSearchPlantVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/02/22.
//

import UIKit

class MyPageSearchPlantVC: UIViewController {

    @IBOutlet weak var plantTV: UITableView!
    @IBOutlet weak var plantSearchBar: UISearchBar!
    @IBOutlet weak var addFloatingBtn: UIButton!
    
    var mypagePlantArray: [MypagefriendsData] = []
    var filteredPlant: [MypagefriendsData] = []
    var filteredData: [MyPlantData] = []
//    var filteredPlant: [MyPlantData] = []
    
    var myCherishId: [Int] = []
    
    var plantIsSelected = false

    var checkSearch: Int = 0
    
    private var selectedPlant: Int? {
        didSet {
            plantTV.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.tabBarController?.tabBar.isHidden = true
        plantTV.separatorStyle = .none
        plantTV.delegate = self
        plantTV.dataSource = self
        plantSearchBar.delegate = self
        setPlantData()
        setSearchBar()
        plantTV.reloadData()
        filteredPlant = mypagePlantArray
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setSearchBar() {
        plantSearchBar.placeholder = "식물 검색"
        plantSearchBar.setImage(UIImage(named: "icn_search_box"), for: UISearchBar.Icon.search, state: .normal)
        plantSearchBar.layer.borderWidth = 0
        plantSearchBar.searchBarStyle = .minimal
        plantSearchBar.setSearchFieldBackgroundImage(UIImage(named: "search_box"), for: .normal)
        plantSearchBar.sizeToFit()
        plantSearchBar.searchTextField.sizeToFit()
        plantSearchBar.searchTextField.textColor = UIColor.black
        plantSearchBar.searchTextField.font = UIFont.init(name: "NotoSansCJKKR-Regular", size: 14)
    }

    func setPlantData(){
        let myPageUserIdx = UserDefaults.standard.integer(forKey: "userID")
        MypageService.shared.inquireMypageView(idx: myPageUserIdx) { [self]
            (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let mypageData = data as? MypageData {
                    mypagePlantArray = mypageData.result
                    print("여기는 영등포")
                    print(mypagePlantArray)
                    plantTV.reloadData()
                }
            case .requestErr(let msg):
                print(msg)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    private func updateSelectedIndex(_ index: Int) {
        selectedPlant = index
    }
    
    @IBAction func moveToAddUser(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "AddUser", bundle: nil)
        
        guard let dvc = storyBoard.instantiateViewController(identifier: "SelectFriendSearchBar") as? SelectFriendSearchBar else {return}
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    }

extension MyPageSearchPlantVC: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredPlant == nil {
            return mypagePlantArray.count
        }
        return filteredPlant.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = plantTV.dequeueReusableCell(withIdentifier: "MySearchPlantCell") as! MySearchPlantCell
        cell.selectionStyle = .none
        
        // 여기 search bar 썼냐, 안썼냐로 분기처리 해야됨
        if mypagePlantArray.count != 0 {
            let url = URL(string: mypagePlantArray[indexPath.row].thumbnailImageURL ?? "")
            DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                let imageData = try? Data(contentsOf: url!)
                DispatchQueue.main.async(execute: { [self]() -> Void in
                    cell.setProperties(imageData!, mypagePlantArray[indexPath.row].nickname, mypagePlantArray[indexPath.row].name, mypagePlantArray[indexPath.row].dDay)
                })
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        plantIsSelected = true
        //        let vc = MyPageVC()
        print("2: my plant임 ㅎㅇㅎㅇ")
        //        print(vc.myPlantID)
        
        var myCherish: [Int] = UserDefaults.standard.array(forKey: "plantIDArray")! as? [Int] ?? [Int]()
        print(myCherish)
        
        var keyId = myCherish[indexPath.row]
        
        UserDefaults.standard.set(keyId, forKey: "selectedCherish")
        
        // plantIsSelected 값 UserDefaults에 넣기
        UserDefaults.standard.set(plantIsSelected, forKey: "plantIsSelected")
        UserDefaults.standard.set(plantIsSelected, forKey: "calendarPlantIsSelected")
        print(UserDefaults.standard.bool(forKey: "plantIsSelected"))
        print(UserDefaults.standard.integer(forKey: "selectedCherish"))
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "PlantDetail", bundle: nil)
        
        guard let dvc = storyBoard.instantiateViewController(identifier: "PlantDetailVC") as? PlantDetailVC else { return }
        
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}

extension MyPageSearchPlantVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPlant = []
        
        if searchText == "" {
            filteredPlant = mypagePlantArray
        }
        else {
            checkSearch = 1
            for plant in filteredPlant {
                if plant.name.contains(searchText) {
                    
            }
        }
        self.plantTV.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        plantSearchBar.searchTextField.resignFirstResponder()
    }
//        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//            self.plantSearchBar.endEditing(true)
//        }

        
    }
}
