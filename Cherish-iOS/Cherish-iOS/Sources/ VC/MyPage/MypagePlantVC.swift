//
//  MypagePlantVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/07.
//

import UIKit

class MypagePlantVC: UIViewController {
    
    
    @IBOutlet var mypageTV: MyOwnTableView!
    
    var mypagePlantArray: [MypagefriendsData] = []
    
    var myCherishId: [Int] = []
    
    var plantIsSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        mypageTV.delegate = self
        mypageTV.dataSource = self
        mypageTV.separatorStyle = .none
    
        setPlantData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setPlantData(){
        let myPageUserIdx = UserDefaults.standard.integer(forKey: "userID")
        MypageService.shared.inquireMypageView(idx: myPageUserIdx) { [self]
            (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let mypageData = data as? MypageData {
                    mypagePlantArray = mypageData.result
                    
                    // UserDefault에 넣기

                    UserDefaults.standard.set(mypageData.totalCherish, forKey: "totalCherish")

                    UserDefaults.standard.set(try? PropertyListEncoder().encode(mypageData.result), forKey: "cherishResult")
                    
                    DispatchQueue.main.async {
                        mypageTV.reloadData()
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
}

extension MypagePlantVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mypagePlantArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MypagePlantTVC") as! MypagePlantTVC
        cell.selectionStyle = .none
        
        if mypagePlantArray.count != 0 {
            
            /// 이미지 url 처리
            let url = URL(string: mypagePlantArray[indexPath.row].thumbnailImageURL ?? "")
            let imageData = try? Data(contentsOf: url!)
            
            cell.setProperties(imageData!, mypagePlantArray[indexPath.row].nickname, mypagePlantArray[indexPath.row].name, mypagePlantArray[indexPath.row].dDay)
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
        print(UserDefaults.standard.bool(forKey: "plantIsSelected"))
        print(UserDefaults.standard.integer(forKey: "selectedCherish"))
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "PlantDetail", bundle: nil)

        guard let dvc = storyBoard.instantiateViewController(identifier: "PlantDetailVC") as? PlantDetailVC else { return }

        self.navigationController?.pushViewController(dvc, animated: true)
    }
}
