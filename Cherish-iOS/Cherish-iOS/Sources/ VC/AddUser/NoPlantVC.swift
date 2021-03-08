//
//  NoPlantVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/15.
//

import UIKit

class NoPlantVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        guard let dvc = self.storyboard?.instantiateViewController(identifier: "PlantResultVC") as? PlantResultVC else {return}
        dvc.checkPush = true
        print("아직 식물 없으요")
        print(dvc.checkPush)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchUpToAddNC(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "AddUser", bundle: nil)
        if let vc = storyBoard.instantiateViewController(identifier: "SelectFriendSearchBar") as? SelectFriendSearchBar {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
