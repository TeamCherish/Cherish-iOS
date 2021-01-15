//
//  MyPageSearchPlantVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/15.


import UIKit

class MyPageSearchPlantVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var plantTableView: UITableView!
    

    var myCherishPlant: [MypagefriendsData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCherishPlant = UserDefaults.standard.value(forKey: "cherishResult") as! [MypagefriendsData]
        plantTableView.delegate = self
        plantTableView.dataSource = self
    }
    
    @IBAction func backToMyPage(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return myCherishPlant.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = plantTableView.dequeueReusableCell(withIdentifier: "MyPageSearchPlantHeaderCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        
        guard let cell = plantTableView.dequeueReusableCell(withIdentifier: "SearchPlantCell", for: indexPath) as? SearchPlantCell else { return UITableViewCell() }

        if myCherishPlant.count != 0 {
            let url = URL(string: myCherishPlant[indexPath.row].thumbnailImageURL ?? "")
            let imageData = (try? Data(contentsOf: url!))!
            cell.setCellProperty(imageData, myCherishPlant[indexPath.row].nickname, myCherishPlant[indexPath.row].name, myCherishPlant[indexPath.row].dDay)
        }
        cell.selectionStyle = .none
        return cell
    }

}
