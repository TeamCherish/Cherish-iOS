//
//  MyPageSearchPlantVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/02/22.
//

import UIKit
import Alamofire


class MyPageSearchPlantVC: UIViewController {

    @IBOutlet weak var plantTV: UITableView!
    @IBOutlet weak var plantSearchBar: UISearchBar!
    @IBOutlet weak var addFloatingBtn: UIButton!
    
    var mypagePlantArray: [MypagefriendsData] = [] // 서버 통신할 때 받아올 구조체
    var filteredPlant: [SearchMypageFriendData]!
    var plantArr: [SearchMypageFriendData] = [] // 디코딩 안해도 되도록 새로 만든 구조체
    var plantArrCount : Int = 0
    var filteredCount : Int = 0
    
    var myCherishId: [Int] = []
    
    var here: MypageData?
    
    var plantIsSelected = false

    var checkSearch: Int = 0
    var index: Int = 0
    
    // 식물 상세페이지로 넘어가는 로직 관련
    var myCherish: [Int] = []
    var keyId : Int = 0
    
    private var selectedPlant: Int? {
        didSet {
            plantTV.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.tabBarController?.tabBar.isHidden = true
        setSearchBar()
        plantTV.separatorStyle = .none
        plantTV.delegate = self
        plantTV.dataSource = self
        plantSearchBar.delegate = self
        setPlantData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 식물 수정한 결과 가져오기 위함!
        // plantTV.reloadData()
        setPlantData()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setSearchBar() {
        let frame = CGRect(x: 0, y: 0, width: 343, height: 44)
        plantSearchBar.frame = frame
        plantSearchBar.placeholder = "식물 검색"
        plantSearchBar.setImage(UIImage(named: "icn_search_box"), for: UISearchBar.Icon.search, state: .normal)
        plantSearchBar.layer.borderWidth = 0
        plantSearchBar.searchBarStyle = .minimal
        plantSearchBar.setSearchFieldBackgroundImage(UIImage(named: "search_box"), for: .normal)
        plantSearchBar.searchTextPositionAdjustment = UIOffset(horizontal: 12.0, vertical: 0.0)
        plantSearchBar.setPositionAdjustment(UIOffset(horizontal: 10.0, vertical: 0.0), for: .search)
//        plantSearchBar.frame = CGRect(x: 16, y: 0, width: 200, height: 44)
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
                    plantArr = []
                    if mypagePlantArray.count != 0 {
                        for _ in 0...mypagePlantArray.count - 1 {
                            plantArr.append(contentsOf: [SearchMypageFriendData(id: 0, dDay: 0, nickname: "", name: "", thumbnailImageURL: "", level: 0, plantID: 0)])
                        }
                        for i in 0...mypagePlantArray.count - 1 {
                            plantArr[i].dDay = mypagePlantArray[i].dDay
                            plantArr[i].id = mypagePlantArray[i].id
                            plantArr[i].level = mypagePlantArray[i].level
                            plantArr[i].name = mypagePlantArray[i].name
                            plantArr[i].nickname = mypagePlantArray[i].nickname
                            plantArr[i].plantID = mypagePlantArray[i].plantID
                            plantArr[i].thumbnailImageURL = mypagePlantArray[i].thumbnailImageURL
                        }
                        plantArrCount = plantArr.count
                        filteredPlant = plantArr
                        plantTV.reloadData()
                    }
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
            print("numberOfRowsInSection - nil")
            print(plantArrCount)
            return plantArrCount
        }
        print("numberOfRowsInSection")
        print(filteredPlant.count)
        return filteredPlant.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = plantTV.dequeueReusableCell(withIdentifier: "MySearchPlantCell") as! MySearchPlantCell
        cell.selectionStyle = .none
        
        // 여기 search bar 썼냐, 안썼냐로 분기처리 해야됨
        
        if plantArr.count != 0 {
            if checkSearch == 0 { // search bar 안썼을 때
                let url = URL(string: plantArr[indexPath.row].thumbnailImageURL ?? "")
                print(url)
                DispatchQueue.global(qos: .background).async(execute: {() -> Void in
                    let imageData = try? Data(contentsOf: url!)
                    DispatchQueue.main.async(execute: { [self]() -> Void in
                        cell.setProperties(imageData!, plantArr[indexPath.row].nickname, plantArr[indexPath.row].name + " Lv.\(String(describing: plantArr[indexPath.row].level!))", plantArr[indexPath.row].dDay)
                    })
                })
            }
            else { // search bar 썼을 때
                let plant = filteredPlant[indexPath.row]
                let currentIndex = indexPath.row
                let selected = currentIndex == selectedPlant
                
                let searchURL = URL(string: filteredPlant[indexPath.row].thumbnailImageURL ?? "")
                DispatchQueue.global(qos: .background).async(execute: {() -> Void in
                    let searchImgData = try? Data(contentsOf: searchURL!)
                    DispatchQueue.main.async(execute: { [self]() -> Void in
                        cell.setProperties(searchImgData!, plant.nickname, plant.name+" Lv.\(String(describing: plant.level!))", plant.dDay)
                    })
                })
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "PlantDetail", bundle: nil)
        guard let dvc = storyBoard.instantiateViewController(identifier: "PlantDetailVC") as? PlantDetailVC else { return }

        // 분기 처리
        // searchBar 썼으면 myCherish 배열 다시 만들어서 사용해야할듯 -> filtered에 append할 때 같이 넣어주기
        
        if checkSearch == 0 { // searchBar 안썼을 때 -> userDefaults에 저장된 배열 사용한다
            plantIsSelected = true
            myCherish = UserDefaults.standard.array(forKey: "plantIDArray")! as? [Int] ?? [Int]()
            keyId = myCherish[indexPath.row]
        }
        else { // searchBar 썼을 때 -> searchBar textDidChange에서 값 다시 넣어준 배열 사용한다
            plantIsSelected = true
            keyId = myCherish[indexPath.row]
        }
        
        UserDefaults.standard.set(keyId, forKey: "selectedCherish")
        
        // plantIsSelected 값 UserDefaults에 넣기
        UserDefaults.standard.set(plantIsSelected, forKey: "plantIsSelected")
        UserDefaults.standard.set(plantIsSelected, forKey: "calendarPlantIsSelected")
        print(UserDefaults.standard.bool(forKey: "plantIsSelected"))
        print(UserDefaults.standard.integer(forKey: "selectedCherish"))
        
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}

extension MyPageSearchPlantVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filteredPlant = []
        
        if searchText == "" {
            checkSearch = 0
            myCherish = []
            filteredPlant = plantArr
        }
        else {
            checkSearch = 1
            myCherish = []
            for plant in plantArr {
                if plant.nickname.contains(searchText) {
                    filteredPlant.append(contentsOf: [SearchMypageFriendData(id: plant.id, dDay: plant.dDay, nickname: plant.nickname, name: plant.name, thumbnailImageURL: plant.thumbnailImageURL, level: plant.level, plantID: plant.plantID)])
                    // 여기서 검색된 데이터의 plantId값들 배열에 append -> 식물 상세 페이지 넘어갈 때 쓸 값임
                    myCherish.append(plant.id)
                }
            }
            filteredCount = filteredPlant.count
        }
        self.plantTV.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        plantSearchBar.searchTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.plantSearchBar.endEditing(true)
    }
}
