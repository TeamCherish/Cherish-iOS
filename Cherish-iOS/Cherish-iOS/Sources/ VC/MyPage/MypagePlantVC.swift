//
//  MypagePlantVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/07.
//

import UIKit

class MypagePlantVC: UIViewController {

    
    @IBOutlet var mypageTV: MyOwnTableView!
    var MypagePlantArray: [MypagePlantData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        mypageTV.delegate = self
        mypageTV.dataSource = self
        mypageTV.separatorStyle = .none
        setPlantData()
    }
    
    func setPlantData(){
        
        MypagePlantArray.append(contentsOf: [
            MypagePlantData(imageURL: "mainImgUser2", nickname: "남궁둥이", plantType: "스투키 Lv.3", wateringDday: "10"),
            MypagePlantData(imageURL: "mainImgUser1", nickname: "훌렁이", plantType: "민들레 Lv.2", wateringDday: "1"),
            MypagePlantData(imageURL: "mainImgUser4", nickname: "끈끈이", plantType: "스투키 Lv.3", wateringDday: "5")
        ])
        
        print(MypagePlantArray)
    }
}

extension MypagePlantVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MypagePlantArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MypagePlantTVC") as! MypagePlantTVC
        
        cell.setProperties(MypagePlantArray[indexPath.row].imageURL, MypagePlantArray[indexPath.row].nickname, MypagePlantArray[indexPath.row].plantType, MypagePlantArray[indexPath.row].wateringDday)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
}
