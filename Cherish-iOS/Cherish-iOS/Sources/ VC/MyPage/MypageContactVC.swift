//
//  MypageContactVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/07.
//

import UIKit

class MypageContactVC: UIViewController {

    @IBOutlet var mypageContactTV: MyOwnTableView!
    var mypageContactArray: [MypageContactData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        mypageContactTV.delegate = self
        mypageContactTV.dataSource = self
        mypageContactTV.separatorStyle = .none
        setPlantData()
    }
    
    func setPlantData(){
        
        mypageContactArray.append(contentsOf: [
            MypageContactData(imageURL: "mainImgUser2", friendsName: "남궁둥이", friendsContact: "010.0000.0000"),
            MypageContactData(imageURL: "mainImgUser1", friendsName: "훌렁이", friendsContact: "010.0000.0000"),
            MypageContactData(imageURL: "mainImgUser4", friendsName: "끈끈이", friendsContact: "010.0000.0000")
        ])
        
        for i in 0...7 {
            if mypageContactArray.count < 8 {
                mypageContactArray.append(MypageContactData(imageURL: "", friendsName: "", friendsContact: ""))
            }
        }
        print(mypageContactArray)
    }
}

extension MypageContactVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mypageContactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MypageContactTVC") as! MypageContactTVC
        
        cell.setProperties(mypageContactArray[indexPath.row].imageURL, mypageContactArray[indexPath.row].friendsName, mypageContactArray[indexPath.row].friendsContact)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
}
