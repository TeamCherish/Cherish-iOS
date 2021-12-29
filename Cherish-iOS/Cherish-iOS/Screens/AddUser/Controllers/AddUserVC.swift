//
//  NoPlantVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/15.
//

import UIKit

class AddUserVC: BaseController {

    @IBOutlet weak var addBtn: UIButton!{
        didSet{
            addBtn.backgroundColor = .seaweed
            addBtn.makeRounded(cornerRadius: 25.0)
            addBtn.isEnabled = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        UserDefaults.standard.set(false, forKey: "isPlantExist")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func touchUpToAddNC(_ sender: UIButton) {
        print("hello")
        if let vc = self.storyboard?.instantiateViewController(identifier: "SelectFriendSearchBar") as? SelectFriendSearchBar {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
