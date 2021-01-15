//
//  MyPageSearchPlantVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/15.
//

import UIKit

class MyPageSearchPlantVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var plantSearchBar: UISearchBar!
    @IBOutlet weak var plantCompleteBtn: UIButton!
    @IBOutlet weak var plantTableView: UITableView!
    
    var myCherishPlant: [MypagefriendsData] = []
    
//    var myCherishPlant = UserDefaults.standard.array(forKey: "cherishResult")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantCompleteBtn.isHidden = true
//        myCherishPlant = UserDefaults.standard.array(forKey: "cherishResult")!
        // Do any additional setup after loading the view.
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
        let cell = plantTableView.dequeueReusableCell(withIdentifier: "SearchPlantCell", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }

}
